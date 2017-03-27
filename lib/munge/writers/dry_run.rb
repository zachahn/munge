module Munge
  module Writers
    # NoOp driver for writing files. This is used to compute dry-runs.
    class DryRun
      # Pretends to write, but actually does nothing
      #
      # @param _abspath [String]
      # @param _content [String]
      def write(_abspath, _content)
      end

      def exist?(path)
        File.exist?(path)
      end

      def read(path)
        File.read(path)
      end
    end
  end
end
