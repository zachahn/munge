module Munge
  module WriteManager
    class OnlyNeeded
      def initialize(io)
        @io = io
      end

      def on_new(abspath, content)
        @io.write(abspath, content)
      end

      def on_changed(abspath, content)
        @io.write(abspath, content)
      end

      def on_identical(_abspath, _content)
      end
    end
  end
end
