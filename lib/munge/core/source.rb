require_relative "source/item_factory"

module Munge
  module Core
    class Source
      include Enumerable

      def initialize(source_abspath, binary_extensions, location, ignored_basenames)
        @item_factory = ItemFactory.new(source_abspath, binary_extensions, location, ignored_basenames)
        pattern       = File.join(source_abspath, "**", "*")

        @items =
          Dir.glob(pattern)
            .reject { |item_path| File.directory?(item_path) }
            .map    { |item_path| @item_factory.read(item_path) }
            .map    { |item| [item.id, item] }
            .to_h
      end

      def build_virtual_item(*args)
        @item_factory.build_virtual(*args)
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
