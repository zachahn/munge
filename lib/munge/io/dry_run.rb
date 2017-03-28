module Munge
  module Io
    # NoOp driver for writing files. This is used to compute dry-runs.
    class DryRun
      def initialize(driver)
        @driver = driver
      end

      # Pretends to write, but actually does nothing
      #
      # @param _abspath [String]
      # @param _content [String]
      def write(_abspath, _content)
      end

      def exist?(path)
        @driver.exist?(path)
      end

      def read(path)
        @driver.read(path)
      end
    end
  end
end
