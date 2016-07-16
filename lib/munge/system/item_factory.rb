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
        type = item_file_type(relpath)

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
        normalized_content, normalized_frontmatter =
          if item_file_type(relpath) == :text
            parsed = ContentParser.new(content)
            [parsed.content, parsed.frontmatter]
          else
            [content, {}]
          end

        build(
          relpath: relpath,
          content: normalized_content,
          frontmatter: normalized_frontmatter,
          stat: stat
        )
      end

      private

      def file_extensions(filepath)
        extensions = File.basename(filepath).split(".")[1..-1]
        Set.new(extensions)
      end

      def item_file_type(abspath)
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
