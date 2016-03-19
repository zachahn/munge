module Munge
  class Application
    def initialize(system)
      @system = system
    end

    def items
      @system.items
    end

    def nonrouted
      items.select { |item| item.route.nil? }
    end

    def routed
      items.reject { |item| item.route.nil? }
    end

    def write(&block)
      @system.items
        .reject { |item| item.route.nil? }
        .each   { |item| render_and_write(item, &block) }
    end

    def build_virtual_item(relpath, content, **frontmatter)
      @system.items.build(relpath: relpath, content: content, frontmatter: frontmatter)
    end

    def create(*args)
      item = build_virtual_item(*args)
      yield item if block_given?
      @system.items.push(item)
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
