module Munge
  class System
    class Write
      def initialize(output:)
        @output = output
      end

      def write(relpath, content)
        abspath = File.join(@output, relpath)

        FileUtils.mkdir_p(File.dirname(abspath))

        File.write(abspath, content)
      end
    end
  end
end
