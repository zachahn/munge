module Munge
  module Formatters
    class Default
      def initialize
      end

      def call(item, write_status)
        case write_status
        when :new, :changed
          puts "wrote #{item.route}"
        when :identical
          puts "identical #{item.route}"
        when :double_write_error
          raise "attempted to write #{item.route} twice"
        end
      end
    end
  end
end
