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

      def push(item)
        if @items.key?(item.id)
          raise "item with id `#{item.id}` already exists"
        else
          @items[item.id] = item
        end
      end

      def [](id)
        if @items.key?(id)
          @items[id]
        else
          raise "item not found (#{id})"
        end
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
