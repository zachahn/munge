module Munge
  class System
    class Router
      def initialize(processor:)
        @registries = { route: [], filepath: [] }
        @processor = processor
      end

      def register(router)
        case router.type
        when :route
          @registries[:route].push(router)
        when :filepath
          @registries[:filepath].push(router)
        else
          raise Errors::InvalidRouterError, router.type
        end
      end

      def route(item)
        path = route_mapper(item, :route)
        Util::Path.ensure_abspath(path)
      end

      def filepath(item)
        initial_route = route(item)
        path = route_mapper(item, :filepath, initial_route)
        Util::Path.ensure_relpath(path)
      end

      private

      def route_mapper(item, method_name, initial_route = nil)
        if !item.route && !initial_route
          raise Errors::ItemHasNoRouteError, item.relpath
        end

        itemish = Itemish.new(item, @processor)

        @registries[method_name]
          .select { |router| router.type == method_name }
          .reduce(initial_route || item.route) do |route, router|
            if router.match?(route, itemish)
              router.call(route, itemish)
            else
              route
            end
          end
      end
    end
  end
end
