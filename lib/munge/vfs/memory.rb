module Munge
  module Vfs
    class Memory
      def initialize(fs = {})
        @fs = fs
      end

      def write(relpath, contents)
        @fs[relpath] = contents
      end

      def read(relpath)
        @fs[relpath]
      end

      def rm(relpath)
        @fs.delete(relpath)
      end

      def exist?(relpath)
        @fs.key?(relpath)
      end

      def stat(relpath)
        nil
      end

      def tree
        @fs.keys
      end
    end
  end
end
