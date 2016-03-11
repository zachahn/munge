module Munge
  class Runner
    def initialize(source:, router:, alterant:, writer:)
      @source   = source
      @router   = router
      @alterant = alterant
      @writer   = writer
    end

    def write
      block = lambda do |item, did_write|
        if did_write
          puts "wrote #{item.route}"
        else
          puts "identical #{item.route}"
        end
      end

      @source
        .reject { |item| item.route.nil? }
        .each   { |item| render_and_write(item, &block) }
    end

    private

    def render_and_write(item, &block)
      relpath = @router.filepath(item)

      write_status = @writer.write(relpath, @alterant.transform(item))

      if block_given?
        block.call(item, write_status)
      end
    end
  end
end
