require_relative "source/item_factory"

module Munge
  module Core
    class Source
      include Enumerable

      def initialize(source_abspath, binary_extensions = [])
        item_factory = ItemFactory.new(source_abspath, binary_extensions)
        pattern      = File.join(source_abspath, "**", "*")

        @items = Dir[pattern]
                 .reject { |item_path| File.directory?(item_path) }
                 .map    { |item_path| item_factory.create(item_path) }
      end

      def each
        return enum_for(:each) unless block_given?

        @items.each do |item|
          yield item
        end
      end

      def push(virtual_item)
        @items.push(virtual_item)
      end
    end
  end
end
