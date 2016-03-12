module Munge
  module Reporters
    class Default
      def initialize
      end

      def call(item, did_write)
        if did_write
          puts "wrote #{item.route}"
        else
          puts "identical #{item.route}"
        end
      end
    end
  end
end
