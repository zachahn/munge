module Munge
  class System
    class ItemFactory
      # @param text_extensions [Array<String>]
      # @param ignore_extensions [Array<String>] Strings are converted to regex
      def initialize(text_extensions:,
                     ignore_extensions:)
        @text_extensions = text_extensions
        @item_identifier = ItemIdentifier.new(remove_extensions: ignore_extensions)
      end

      # Builds an Item
      #
      # @param relpath [String]
      # @param content [String]
      # @param frontmatter [Hash]
      # @param stat [File::Stat]
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

      # Parses frontmatter and builds an Item, given a text string
      #
      # @param relpath [String]
      # @param content [String]
      # @param stat [File::Stat]
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

      def item_file_type(abspath)
        if has_text_extension?(abspath)
          :text
        else
          :binary
        end
      end

      def has_text_extension?(filepath)
        extensions = Munge::Util::Path.extnames(filepath)
        intersection = extensions & @text_extensions

        intersection.any?
      end
    end
  end
end
