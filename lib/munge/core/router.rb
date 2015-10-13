module Munge
  module Core
    class Router
      def initialize(index:, keep_extensions:)
        @index          = index
        @keep_extensions = keep_extensions
      end

      def route(item)
        fail "item has no route" unless item.route

        item.route
      end

      def filepath(item)
        fail "item has no route" unless item.route

        relroute       = relativeize(item.route)
        main_extension = item.extensions.first

        path =
          if keep_extension?(main_extension)
            "#{relroute}.#{main_extension}"
          else
            "#{relroute}/#{@index}"
          end

        relativeize(path)
      end

      private

      def relativeize(path)
        while path[0] == "/"
          path = path[1..-1]
        end

        path
      end

      def keep_extension?(extension)
        @keep_extensions.include?(extension)
      end
    end
  end
end