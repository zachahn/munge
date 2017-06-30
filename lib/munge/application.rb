module Munge
  # This class is one of the main interfaces users would interact with. This
  # provides methods to create and iterate through items.
  class Application
    def initialize(conglomerate)
      @conglomerate = conglomerate
    end

    # @return [Array<Item>]
    def items
      @conglomerate.items
    end

    # @return [Array<Item>]
    def nonrouted
      items.select { |item| item.route.nil? }
    end

    # @return [Array<Item>]
    def routed
      items.select(&:route)
    end

    # Builds an Item
    #
    # @return [Item]
    def build_virtual_item(relpath, content, **frontmatter)
      @conglomerate.item_factory.build(relpath: relpath, content: content, frontmatter: frontmatter)
    end

    # Creates an Item and inserts it into the registry of Items.
    #
    # @see #build_virtual_item
    # @param relpath [String]
    # @param content [String]
    # @param frontmatter [Hash]
    # @return [Array<Item>]
    def create(*args)
      item = build_virtual_item(*args)
      @conglomerate.items.push(item)
      [item]
    end

    # Returns parts of Conglomerate
    #
    # @private
    def vomit(component_name)
      @conglomerate.public_send(component_name)
    end
  end
end
