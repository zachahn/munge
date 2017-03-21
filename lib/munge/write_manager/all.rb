module Munge
  module WriteManager
    class All
      def initialize(io)
        @io = io
        @written_routes = []
      end

      attr_reader :written_routes

      def on_new(route, abspath, content)
        @io.write(abspath, content)
        @written_routes.push(abspath)
      end

      def on_changed(route, abspath, content)
        @io.write(abspath, content)
        @written_routes.push(abspath)
      end

      def on_identical(route, abspath, content)
        @io.write(abspath, content)
        @written_routes.push(abspath)
      end
    end
  end
end
