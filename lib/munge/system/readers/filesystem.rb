module Munge
  class System
    module Reader
      class Filesystem
        include Enumerable

        def initialize(source_path)
          @source_path = source_path
        end

        def each
          return enum_for(:each) unless block_given?

          filepaths =
            Dir.glob(File.join(@source_path, "**", "*"))
              .select { |path| File.file?(path) }

          filepaths.each do |abspath|
            filehash = Hash[
              relpath: compute_relpath(abspath),
              content: compute_content(abspath),
              stat: compute_stat(abspath)
            ]

            yield filehash
          end
        end

        private

        def compute_stat(abspath)
          File.stat(abspath)
        end

        def compute_relpath(abspath)
          folder = Pathname.new(@source_path)
          file   = Pathname.new(abspath)

          file.relative_path_from(folder).to_s
        end

        def compute_content(abspath)
          File.read(abspath)
        end
      end
    end
  end
end
