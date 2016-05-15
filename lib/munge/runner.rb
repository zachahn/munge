module Munge
  class Runner
    def initialize(items:, router:, alterant:, writer:, formatter:, verbosity:, destination:)
      @items         = items
      @router        = router
      @alterant      = alterant
      @writer        = writer
      @reporter      = Munge::Reporter.new(formatter: formatter, verbosity: verbosity)
      @write_manager = Munge::WriteManager.new(driver: File)
      @destination   = destination
    end

    def write
      @reporter.start

      @items
        .reject { |item| item.route.nil? }
        .each   { |item| render_and_write(item) }

      @reporter.done
    end

    private

    def render_and_write(item)
      relpath = @router.filepath(item)
      abspath = File.join(@destination, relpath)
      content = @alterant.transform(item)

      write_status = @write_manager.status(abspath, content)

      case write_status
      when :new, :changed
        @writer.write(abspath, content)
      when :double_write_error
        raise "attempted to write #{item.route} twice"
      when :identical
        # Defer to the reporter
      end

      @reporter.call(item, relpath, write_status)
    end
  end
end
