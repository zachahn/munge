module Munge
  module Vfs
    class Filesystem
      def initialize(root)
        @root = root
      end

      def write(relpath, contents)
        FileUtils.mkdir_p(File.dirname(File.join(@root, relpath)))

        File.write(File.join(@root, relpath), contents)
      end

      def read(relpath)
        File.read(File.join(@root, relpath))
      end

      def exist?(relpath)
        File.exist?(File.join(@root, relpath))
      end

      def stat(relpath)
        File.stat(File.join(@root, relpath))
      end

      def tree
        pattern = File.join(@root, "**", "*")

        files = Dir.glob(pattern).select { |path| File.file?(path) }

        files.map do |file|
          root_path = Pathname.new(@root)
          file_path = Pathname.new(file)

          file_path.relative_path_from(root_path).to_s
        end
      end
    end
  end
end
