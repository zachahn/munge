module Munge
  module Core
    class Router
      def initialize(index:, keep_extensions:)
        @index          = index
        @keep_extensions = keep_extensions
      end

      def route(item)
        fail "item has no route" unless item.route

        if keep_extension?(item)
          "/#{filepath(item)}"
        else
          item.route
        end
      end

      def filepath(item)
        fail "item has no route" unless item.route

        relroute = relativeize(item.route)

        path =
          if keep_extension?(item)
            "#{relroute}.#{main_extension(item)}"
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

      def keep_extension?(item)
        @keep_extensions.include?(main_extension(item))
      end

      def main_extension(item)
        item.extensions.first
      end
    end
  end
end
