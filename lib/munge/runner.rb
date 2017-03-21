module Munge
  class Runner
    def initialize(items:, router:, processor:, io:, reporter:, destination:, manager:)
      @items = items
      @router = router
      @processor = processor
      @io = io
      @reporter = reporter
      @destination = destination
      @manager = manager
      @written_paths = []
    end

    def write
      @reporter.start

      @items
        .reject { |item| item.route.nil? }
        .each { |item| render_and_write(item) }

      @reporter.done

      @manager.written_routes
    end

    private

    def render_and_write(item)
      relpath = @router.filepath(item)
      abspath = File.join(@destination, relpath)
      route = @router.route(item)
      content = @processor.transform(item)

      write_status = status(abspath, content)

      case write_status
      when :new
        @manager.on_new(route, abspath, content)
      when :changed
        @manager.on_changed(route, abspath, content)
      when :identical
        @manager.on_identical(route, abspath, content)
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
