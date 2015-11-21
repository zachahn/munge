module Munge
  module Core
    class Source
      include Enumerable

      def initialize(item_factory:,
                     items:)
        @item_factory = item_factory

        @items =
          items
            .map { |item| parse(**item) }
            .map { |item| [item.id, item] }
            .to_h
      end

      def build(**args)
        @item_factory.build(**prune_args(args))
      end

      def parse(**args)
        @item_factory.parse(**prune_args(args))
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

      private

      def prune_args(args)
        args.select { |k, v| %i(relpath content frontmatter stat).include?(k) }
      end
    end
  end
end
