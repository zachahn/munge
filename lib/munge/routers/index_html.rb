module Munge
  module Router
    class IndexHtml
      def initialize(html_extensions:, index:)
        @html_extensions = html_extensions
        @index           = index
      end

      def match?(initial_route, content, item)
        item_is_html?(item) && route_needs_extension?(initial_route)
      end

      def filepath(initial_route, _content, _item)
        File.join(initial_route, @index)
      end

      private

      def item_is_html?(item)
        intersection = item.extensions & @html_extensions

        return intersection.length > 0
      end

      def route_needs_extension?(route)
        basename = File.basename(route)

        return !basename.include?(".")
      end
    end
  end
end