module Munge
  module Reporters
    class Default
      def initialize
      end

      def call(item, write_status)
        case write_status
        when :different
          puts "wrote #{item.route}"
        when :identical
          puts "identical #{item.route}"
        when :double_write_error
          fail "attempted to write #{item.route} twice"
        end
      end
    end
  end
end