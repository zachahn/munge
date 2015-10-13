module Munge
  module Core
    class Write
      def initialize(output, index)
        @output = output
        @index  = index
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
