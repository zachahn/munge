module Munge
  class Runner
    def initialize(source:, router:, alterant:, writer:, reporter:)
      @source   = source
      @router   = router
      @alterant = alterant
      @writer   = writer
      @reporter = reporter
      @write_manager = Munge::WriteManager.new(driver: File)
    end

    def write
      @source
        .reject { |item| item.route.nil? }
        .each   { |item| render_and_write(item) }
    end

    private

    def render_and_write(item)
      relpath = @router.filepath(item)
      content = @alterant.transform(item)

      write_status = @write_manager.status(relpath, content)

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
