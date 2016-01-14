require_relative "item_factory/content_parser"

module Munge
  module Core
    class ItemFactory
      def initialize(text_extensions:,
                     ignore_extensions:)
        @text_extensions   = Set.new(text_extensions)
        @ignore_extensions = ignore_extensions
      end

      def build(relpath:,
                content:,
                frontmatter: {},
                stat: nil)
        type = compute_file_type(relpath)

        id =
          if @ignore_extensions || type == :text
            compute_id(relpath)
          else
            relpath
          end

        Munge::Item.new(
          relpath: relpath,
          content: content,
          frontmatter: frontmatter,
          stat: stat,
          type: type,
          id: id
        )
      end

      def parse(relpath:,
                content:,
                stat: nil)
        type = compute_file_type(relpath)

        if type == :text
          parsed = Munge::Core::ItemFactory::ContentParser.new(content)

          build(
            relpath: relpath,
            content: parsed.content,
            frontmatter: parsed.frontmatter,
            stat: stat
          )
        else
          build(
            relpath: relpath,
            content: content,
            frontmatter: {},
            stat: stat
          )
        end
      end

      private

      def file_extensions(filepath)
        extensions = File.basename(filepath).split(".")[1..-1]
        Set.new(extensions)
      end

      def compute_file_type(abspath)
        exts = file_extensions(abspath)

        if exts.intersect?(@text_extensions)
          :text
        else
          :binary
        end
      end

      def compute_id(relpath)
        dirname  = Munge::Util::Path.dirname(relpath)
        basename =
          if @ignore_extensions
            Munge::Util::Path.basename_no_extension(relpath)
          else
            Munge::Util::Path.basename_one_extension(relpath)
          end

        id = []

        unless dirname == ""
          id.push(dirname)
        end

        id.push(basename)

        id.join("/")
      end
    end
  end
end
