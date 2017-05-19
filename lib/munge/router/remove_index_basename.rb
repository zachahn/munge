module Munge
  module Router
    class RemoveBasename
      def initialize(extensions:, basenames:, keep_explicit:)
        @extensions = extensions
        @basenames = basenames
        @keep_if_explicit_extension = keep_explicit
      end

      def type
        :route
      end

      def match?(initial_route, item)
        item_has_extension?(item) && route_has_basename?(initial_route)
      end

      def call(initial_route, _item)
        Munge::Util::Path.dirname(initial_route)
      end

      private

      def item_has_extension?(item)
        intersection = item.extensions & @extensions

        !intersection.empty?
      end

      def route_has_basename?(route)
        if @keep_if_explicit_extension
          route_extensions = Munge::Util::Path.extnames(route)

          if route_extensions.any?
            return false
          end
        end

        route_basename = Munge::Util::Path.basename_no_extension(route)

        @basenames.include?(route_basename)
      end
    end
  end
end
