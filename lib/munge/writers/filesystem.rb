module Munge
  module Writers
    class Filesystem
      def write(abspath, content)
        FileUtils.mkdir_p(File.dirname(abspath))

        File.write(abspath, content)
      end
    end
  end
end
