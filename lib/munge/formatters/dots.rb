module Munge
  module Formatters
    class Dots
      def initialize
        @news       = []
        @changeds   = []
        @identicals = []
        @total      = 0
      end

      def call(_item, relpath, write_status, _should_print)
        @total += 1

        case write_status
        when :new
          @news.push(relpath)
          print Rainbow("W").green
        when :changed
          @changeds.push(relpath)
          print Rainbow("W").yellow
        when :identical
          @identicals.push(relpath)
          print "."
        end
      end

      def start
        @start_time = Time.now

        puts "Building:"
      end

      def done
        @done_time = Time.now

        # Print a newline after the line of dots
        puts

        list!

        summary!
      end

      private

      def list!
        lists = [
          [@news, "New items:"],
          [@changeds, "Updated items:"]
        ]

        lists.each do |list, title|
          if list.empty?
            skip
          end

          puts
          puts title
          puts
          puts list.join(", ")
        end
      end

      def summary!
        write_summary = [
          "Created #{@news.size}",
          "Updated #{@changeds.size}",
          "Ignored #{@identicals.size}"
        ]

        puts
        puts "Processed #{@total} in #{@done_time - @start_time} seconds"
        puts
        puts write_summary.join(", ")
      end
    end
  end
end
