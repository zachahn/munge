module Munge
  module Item
    class Virtual < Base
      def initialize(relpath, kontent, frontmatter = nil)
        content =
          if kontent.is_a?(String)
            Munge::Attribute::Content.new(kontent, frontmatter)
          else
            kontent
          end

        super(relpath, content)
      end

      def relpath
        @path
      end

      def virtual?
        true
      end

      def content=(new_content)
        @content.content = new_content
      end
    end
  end
end
