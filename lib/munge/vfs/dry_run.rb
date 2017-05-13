module Munge
  module Vfs
    class DryRun
      def initialize(vfs)
        @vfs = vfs
      end

      def read(relpath)
        @vfs.read(relpath)
      end

      def exist?(relpath)
        @vfs.exist?(relpath)
      end

      def write(_relpath, _content)
      end

      def stat(relpath)
        @vfs.stat(relpath)
      end

      def tree
        @vfs.tree
      end
    end
  end
end
