module Munge
  class System
    class Write
      def initialize(output:)
        @output = output
      end

      def write(relpath, content)
        abspath = File.join(@output, relpath)

        FileUtils.mkdir_p(File.dirname(abspath))

        if File.exist?(abspath) && File.read(abspath) == content
          return false
        else
          File.write(abspath, content)
          true
        end
      end
    end
  end
end
