module Munge
  module Formatter
    class Default
      def initialize
        @new_count = 0
        @changed_count = 0
        @identical_count = 0
        @reported_count = 0
      end

      def call(_item, relpath, write_status, should_print)
        case write_status
        when :new
          report_new(relpath, should_print)
        when :changed
          report_changed(relpath, should_print)
        when :identical
          report_identical(relpath, should_print)
        end
      end

      def start
        @start_time = Time.now

        puts "Started build"
      end

      def done
        @done_time = Time.now

        report = [
          "Wrote #{@new_count + @changed_count}",
          "Processed #{@new_count + @changed_count + @identical_count}"
        ]

        puts report.join(", ")
        puts "Took #{@done_time - @start_time} seconds"
      end

      private

      def report_new(relpath, should_print)
        @new_count += 1

        if should_print
          puts report(Rainbow("created").green, relpath)
        end
      end

      def report_changed(relpath, should_print)
        @changed_count += 1

        if should_print
          puts report(Rainbow("updated").green, relpath)
        end
      end

      def report_identical(relpath, should_print)
        @identical_count += 1

        if should_print
          puts report(Rainbow("identical").yellow, relpath)
        end
      end

      def report(action, relpath)
        @reported_count += 1

        %(#{action.rjust(24)}   #{relpath})
      end
    end
  end
end
