module Munge
  class Runner
    def initialize(source:, router:, alterant:, writer:, reporter:, destination:)
      @source   = source
      @router   = router
      @alterant = alterant
      @writer   = writer
      @reporter = reporter
      @write_manager = Munge::WriteManager.new(driver: File)
      @destination   = destination
    end

    def write
      @source
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
      when :different
        @writer.write(relpath, content)
      when :identical, :double_write_error
        # we'll defer all other cases to the reporter
      end

      @reporter.call(item, write_status)
    end
  end
end
