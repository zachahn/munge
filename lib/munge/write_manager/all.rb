module Munge
  module WriteManager
    class All
      def initialize(vfs)
        @vfs = vfs
        @written_routes = []
      end

      attr_reader :written_routes

      def on_new(_route, relpath, content)
        @vfs.write(relpath, content)
        @written_routes.push(relpath)
      end

      def on_changed(_route, relpath, content)
        @vfs.write(relpath, content)
        @written_routes.push(relpath)
      end

      def on_identical(_route, relpath, content)
        @vfs.write(relpath, content)
        @written_routes.push(relpath)
      end
    end
  end
end
