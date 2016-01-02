module Munge
  class Application
    def initialize(system)
      @system = system

      @system.alterant.register(Transformer::Tilt.new(@system))

      @system.router.register(Router::AutoAddExtension.new(keep_extensions: system.config[:keep_extensions]))
      @system.router.register(Router::Fingerprint.new(extensions: system.config[:keep_extensions]))
      @system.router.register(Router::IndexHtml.new(html_extensions: system.config[:text_extensions], index: system.config[:index]))
    end

    def source
      @system.source
    end

    def write(&block)
      @system.source
        .reject { |item| item.route.nil? }
        .each   { |item| render_and_write(item, &block) }
    end

    def build_virtual_item(*args)
      @system.source.build(*args)
    end

    def create(*args)
      item = build_virtual_item(*args)
      yield item if block_given?
      @system.source.push(item)
    end

    private

    def render_and_write(item, &block)
      relpath = @system.router.filepath(item)

      write_status = @system.writer.write(relpath, @system.alterant.transform(item))

      if block_given?
        block.call(item, write_status)
      end
    end
  end
end
