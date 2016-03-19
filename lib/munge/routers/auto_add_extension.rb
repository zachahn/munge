module Munge
  module Routers
    class AutoAddExtension
      def initialize(keep_extensions:)
        @keep_extensions = keep_extensions
      end

      def type
        :route
      end

      def match?(initial_route, item)
        item_should_have_extension?(item) && route_doesnt_have_extension?(initial_route)
      end

      def call(initial_route, item)
        add_extension(initial_route, item)
      end

      private

      def add_extension(initial_route, item)
        intersection = item.extensions & @keep_extensions
        extension    = intersection[0]

        "#{initial_route}.#{extension}"
      end

      def item_should_have_extension?(item)
        intersection = item.extensions & @keep_extensions

        !intersection.empty?
      end

      def route_doesnt_have_extension?(initial_route)
        initial_route_extensions = initial_route.split(".")[1..-1]

        intersection = initial_route_extensions & @keep_extensions

        intersection.empty?
      end
    end
  end
end
