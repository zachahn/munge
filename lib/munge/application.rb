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
      items.select(&:route)
    end

    def build_virtual_item(relpath, content, **frontmatter)
      @system.items.build(relpath: relpath, content: content, frontmatter: frontmatter)
    end

    def create(*args)
      item = build_virtual_item(*args)
      @system.items.push(item)
      [item]
    end

    def vomit(component_name)
      @system.public_send(component_name)
    end
  end
end
