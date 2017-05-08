module Munge
  class System
    module Readers
      # Enumerable list of {Munge::Item}s
      class Filesystem
        include Enumerable

        # @param source_path [String]
        def initialize(source_path, item_factory)
          @source_path = source_path
          @item_factory = item_factory
        end

        # @yield [Item]
        # @return [Enumerator]
        def each
          return enum_for(:each) unless block_given?

          filepaths =
            Dir.glob(File.join(@source_path, "**", "*"))
              .select { |path| File.file?(path) }

          filepaths.each do |abspath|
            item =
              @item_factory.parse(
                relpath: compute_relpath(abspath),
                content: compute_content(abspath),
                stat: compute_stat(abspath)
              )

            yield item
          end
        end

        private

        def compute_stat(abspath)
          File.stat(abspath)
        end

        def compute_relpath(abspath)
          folder = Pathname.new(@source_path)
          file = Pathname.new(abspath)

          file.relative_path_from(folder).to_s
        end

        def compute_content(abspath)
          File.read(abspath)
        end
      end
    end
  end
end
