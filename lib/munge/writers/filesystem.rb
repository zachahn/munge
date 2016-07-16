module Munge
  module Writers
    # Filesystem driver for writing files. These drivers can be defined however
    # you wish, as long as the `#write` method accepts an abspath and content.
    class Filesystem
      # Writes content to abspath. Nonexistent directories will be created
      # automatically.
      #
      # @param abspath [String]
      # @param content [String]
      def write(abspath, content)
        FileUtils.mkdir_p(File.dirname(abspath))

        File.write(abspath, content)
      end
    end
  end
end
