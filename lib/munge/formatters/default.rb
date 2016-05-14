module Munge
  module Formatters
    class Default
      def initialize
        @new_count       = 0
        @changed_count   = 0
        @identical_count = 0
      end

      def call(item, write_status, should_print)
        case write_status
        when :new
          @new_count += 1
          report("  created", item, should_print)
        when :changed
          @changed_count += 1
          report("  updated", item, should_print)
        when :identical
          @identical_count += 1
          report("identical", item, should_print)
        when :double_write_error
          raise "attempted to write #{item.route} twice"
        end
      end

      def start
        @start_time = Time.now
      end

      def done
        @done_time = Time.now

        puts "Wrote #{@new_count + @changed_count}, Identical #{@identical_count}"
        puts "Took #{@done_time - @start_time} seconds"
      end

      private

      def report(action, item, should_print)
        if should_print
          puts "  #{action} #{item.relpath} => #{item.route}"
        end
      end
    end
  end
end
