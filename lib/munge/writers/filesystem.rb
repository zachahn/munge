module Munge
  class System
    class Write
      def initialize(output:)
      end

      def write(abspath, content)
        FileUtils.mkdir_p(File.dirname(abspath))

        File.write(abspath, content)
      end
    end
  end
end
