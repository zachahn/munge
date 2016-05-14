module Munge
  class Reporter
    def initialize(formatter:, verbosity:)
      @formatter = formatter
      @verbosity = verbosity
    end

    def call(item, write_status)
      should_print =
        if @verbosity == :all
          true
        elsif @verbosity == :written
          if write_status == :new || write_status == :changed
            true
          end
        elsif @verbosity == :silent
        end

      @formatter.call(item, write_status, should_print || false)
    end

    def start
      @formatter.start
    end

    def done
      @formatter.done
    end
  end
end
