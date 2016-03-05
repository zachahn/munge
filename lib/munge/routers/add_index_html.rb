module Munge
  module Routers
    class AddIndexHtml
      def initialize(html_extensions:, index:)
        @html_extensions = html_extensions
        @index           = index
      end

      def type
        :filepath
      end

      def match?(initial_route, item)
        item_is_html?(item) && route_needs_extension?(initial_route)
      end

      def call(initial_route, _item)
        File.join(initial_route, @index)
      end

      private

      def item_is_html?(item)
        intersection = item.extensions & @html_extensions

        intersection.length > 0
      end

      def route_needs_extension?(route)
        basename = File.basename(route)

        !basename.include?(".")
      end
    end
  end
end
