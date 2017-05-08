module Munge
  class System
    # This class is effectively an Array of Items
    class Collection
      include Enumerable

      # @param [System::ItemFactory] item_factory
      # @param [Array<Hash>] items
      def initialize(items:)
        @items =
          items
            .map { |item| [item.id, item] }
            .to_h
      end

      # @yield [Item]
      # @return [Enumerator]
      def each
        return enum_for(:each) unless block_given?

        @items.each_value do |item|
          yield item
        end
      end

      # @param item [Item]
      # @return [void]
      def push(item)
        if @items.key?(item.id)
          raise Errors::DuplicateItemError, item.id
        else
          @items[item.id] = item
        end
      end

      # @param id [String] ID of item
      # @return [Item]
      def [](id)
        if @items.key?(id)
          @items[id]
        else
          raise Errors::ItemNotFoundError, id
        end
      end

      def freeze
        @items.freeze

        super
      end
    end
  end
end
