module Munge
  class Runner
    def initialize(items:, router:, processor:, reporter:, manager:, vfs:)
      @items = items
      @router = router
      @processor = processor
      @reporter = reporter
      @manager = manager
      @written_paths = []
      @vfs = vfs
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
      route = @router.route(item)
      content = @processor.transform(item)

      write_status = status(relpath, content)

      case write_status
      when :new
        @manager.on_new(route, relpath, content)
      when :changed
        @manager.on_changed(route, relpath, content)
      when :identical
        @manager.on_identical(route, relpath, content)
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

      if !@vfs.exist?(path)
        return :new
      end

      if @vfs.read(path) == content
        return :identical
      end

      :changed
    end
  end
end
