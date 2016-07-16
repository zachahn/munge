module Munge
  module Formatters
    class Dots
      def initialize
        @counts = Hash.new { 0 }
        @relpaths = Hash.new { [] }

        @dots = {
          new:       Rainbow("W").green,
          changed:   Rainbow("W").yellow,
          identical: "."
        }

        @total = 0
      end

      def call(_item, relpath, write_status, should_print)
        @total += 1

        @counts[write_status] += 1

        if should_print
          @relpaths[write_status] += [relpath]
        end

        print @dots[write_status]
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
          [@relpaths[:new], "New items:"],
          [@relpaths[:changed], "Updated items:"],
          [@relpaths[:identical], "Identical items:"]
        ]

        lists.each do |list, title|
          if list.empty?
            next
          end

          puts
          puts title
          puts
          puts list.join(", ")
        end
      end

      def summary!
        write_summary = [
          "Created #{@counts[:new]}",
          "Updated #{@counts[:changed]}",
          "Ignored #{@counts[:identical]}"
        ]

        puts
        puts "Processed #{@total} in #{@done_time - @start_time} seconds"
        puts
        puts write_summary.join(", ")
      end
    end
  end
end
