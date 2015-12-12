module Munge
  module Core
    class Router
      def initialize(alterant:)
        @registry = []
        @alterant = alterant
      end

      def register(router)
        @registry.push(router)
      end

      def route(item)
        route_mapper(item, :route)
      end

      def filepath(item)
        path = route_mapper(item, :filepath)
        remove_opening_slash(path)
      end

      private

      def route_mapper(item, method_name)
        fail "item has no route" unless item.route
        fail "no routers are registered" if @registry.empty?

        content = @alterant.transform(item)

        @registry
          .select { |router| router.public_methods(false).include?(method_name) }
          .inject(item.route) do |route, router|
            if router.match?(route, content, item)
              router.public_send(method_name, route, content, item)
            else
              route
            end
          end
      end

      def remove_opening_slash(path)
        path.slice(%r([^\/]+.*))
      end
    end
  end
end
