module Munge
  module Core
    class Source
      include Enumerable

      def initialize(item_factory:,
                     items:)
        @item_factory = item_factory

        @items =
          items
            .map { |item| build(**item) }
            .map { |item| [item.id, item] }
            .to_h
      end

      def build(**args)
        pruned_args = args.select { |k, v| %i(relpath content frontmatter stat).include?(k) }
        @item_factory.build(**pruned_args)
      end

      def each
        return enum_for(:each) unless block_given?

        @items.each_value do |item|
          yield item
        end
      end

      def push(virtual_item)
        key = virtual_item.id
        @items[key] = virtual_item
      end

      def [](id)
        @items[id]
      end
    end
  end
end
