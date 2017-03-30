module Munge
  class Runner
    def initialize(items:, router:, processor:, io:, reporter:, destination:)
      @items = items
      @router = router
      @processor = processor
      @io = io
      @reporter = reporter
      @destination = destination
      @written_items = []
      @written_paths = []
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

      write_status = status(abspath, content)

      case write_status
      when :new, :changed
        @io.write(abspath, content)
        @written_items.push(route)
      when :double_write_error
        raise Errors::DoubleWriteError, item.route
      end

      @reporter.call(item, relpath, write_status)
    end

    def status(path, content)
      if @written_paths.include?(path)
        return :double_write_error
      end

      @written_paths.push(path)

      if !@io.exist?(path)
        return :new
      end

      if @io.read(path) == content
        return :identical
      end

      :changed
    end
  end
end
