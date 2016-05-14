module Munge
  class Runner
    def initialize(items:, router:, alterant:, writer:, reporter:, destination:)
      @items         = items
      @router        = router
      @alterant      = alterant
      @writer        = writer
      @reporter      = Munge::Reporter.new(formatter: reporter, verbosity: :all)
      @write_manager = Munge::WriteManager.new(driver: File)
      @destination   = destination
    end

    def write
      @items
        .reject { |item| item.route.nil? }
        .each   { |item| render_and_write(item) }
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
      when :identical, :double_write_error
        # we'll defer all other cases to the reporter
      end

      @reporter.call(item, write_status)
    end
  end
end
