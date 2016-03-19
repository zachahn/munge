module Munge
  class Application
    def initialize(system)
      @system = system
    end

    def source
      @system.source
    end

    def build_virtual_item(relpath, content, **frontmatter)
      @system.source.build(relpath: relpath, content: content, frontmatter: frontmatter)
    end

    def create(*args)
      item = build_virtual_item(*args)
      yield item if block_given?
      @system.source.push(item)
    end

    def vomit(component_name)
      @system.public_send(component_name)
    end
  end
end
