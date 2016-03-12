require "munge/reporters/default"

module Munge
  class Runner
    def initialize(source:, router:, alterant:, writer:)
      @source   = source
      @router   = router
      @alterant = alterant
      @writer   = writer
      @reporter = Munge::Reporters::Default.new
    end

    def write
      @source
        .reject { |item| item.route.nil? }
        .each   { |item| render_and_write(item) }
    end

    private

    def render_and_write(item)
      relpath = @router.filepath(item)

      write_status = @writer.write(relpath, @alterant.transform(item))

      @reporter.call(item, write_status)
    end
  end
end
