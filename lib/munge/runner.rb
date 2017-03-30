module Munge
  class Runner
    def initialize(items:, router:, processor:, io:, reporter:, destination:)
      @items = items
      @router = router
      @processor = processor
      @io = io
      @reporter = reporter
      @write_manager = Munge::WriteManager.new(driver: io)
      @destination = destination
      @written_items = []
    end

    def write
      @reporter.start

      @items
        .reject { |item| item.route.nil? }
        .each { |item| render_and_write(item) }

      @reporter.done

      @written_items
    end

    private

    def render_and_write(item)
      relpath = @router.filepath(item)
      abspath = File.join(@destination, relpath)
      route = @router.route(item)
      content = @processor.transform(item)

      write_status = @write_manager.status(abspath, content)

      case write_status
      when :new, :changed
        @io.write(abspath, content)
        @written_items.push(route)
      when :double_write_error
        raise Errors::DoubleWriteError, item.route
      end

      @reporter.call(item, relpath, write_status)
    end
  end
end
