module Munge
  class System
    class Collection
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
        found_item = @items[id]

        if found_item.nil?
          raise "item not found (#{id})"
        end

        found_item
      end

      def freeze
        @items.freeze

        super
      end

      private

      def prune_args(args)
        args.select { |k, _| %i(relpath content frontmatter stat).include?(k) }
      end
    end
  end
end
