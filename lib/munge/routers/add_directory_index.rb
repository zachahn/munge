module Munge
  module Routers
    class AddDirectoryIndex
      def initialize(extensions:, index:)
        @extensions = extensions
        @index = index
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
        intersection = item.extensions & @extensions

        !intersection.empty?
      end

      def route_needs_extension?(route)
        basename = File.basename(route)

        !basename.include?(".")
      end
    end
  end
end
