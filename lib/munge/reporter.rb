module Munge
  class Reporter
    def initialize(formatter:, verbosity:)
      @formatter = formatter
      @verbosity = verbosity
    end

    def call(item, relpath, write_status)
      @formatter.call(item, relpath, write_status, should_print?(write_status))
    end

    def start
      @formatter.start
    end

    def done
      @formatter.done
    end

    private

    def should_print?(write_status)
      case @verbosity
      when :all
        return true
      when :written
        return write_status == :new || write_status == :changed
      when :silent
        return false
      end

      false
    end
  end
end
