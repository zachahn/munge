module Munge
  class System
    class ItemFactory
      def initialize(text_extensions:,
                     ignore_extensions:)
        @text_extensions = Set.new(text_extensions)
        @item_identifier = ItemIdentifier.new(remove_extensions: ignore_extensions)
      end

      def build(relpath:,
                content:,
                frontmatter: {},
                stat: nil)
        type = compute_file_type(relpath)

        id = @item_identifier.call(relpath)

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
          parsed = ContentParser.new(content)

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
    end
  end
end
