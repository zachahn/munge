module Munge
  module Function
    class Clean
      def initialize(memory:, destination:)
        @memory = memory
        @destination = destination
      end

      def call
        orphans = @destination.tree - @memory.tree

        orphans.each do |orphan|
          @destination.rm(orphan)
        end
      end
    end
  end
end
