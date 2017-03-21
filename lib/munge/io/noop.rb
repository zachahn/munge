module Munge
  module Io
    # NoOp driver for writing files. This is used to compute dry-runs.
    class Noop
      # Pretends to write, but actually does nothing
      #
      # @param _abspath [String]
      # @param _content [String]
      def write(_abspath, _content)
      end

      def exist?(_path)
        false
      end

      def read(_path)
        ""
      end

      def rm(_path)
      end

      def rmdir(_path)
      end
    end
  end
end
