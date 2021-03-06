module Munge
  class Conglomerate
    # Enumerable list of {Munge::Item}s
    class Reader
      include Enumerable

      # @param source_path [String]
      def initialize(vfs, item_factory)
        @vfs = vfs
        @item_factory = item_factory
      end

      # @yield [Item]
      # @return [Enumerator]
      def each
        return enum_for(:each) unless block_given?

        filepaths = @vfs.tree

        filepaths.each do |relpath|
          item =
            @item_factory.parse(
              relpath: relpath,
              content: @vfs.read(relpath),
              stat: @vfs.stat(relpath)
            )

          yield item
        end
      end
    end
  end
end
