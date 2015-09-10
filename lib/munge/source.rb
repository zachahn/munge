module Munge
  class Source
    include Enumerable

    def initialize(source_abspath)
      @source_abspath = source_abspath
      @pattern        = File.join(source_abspath, "**", "*")

      @items = Dir[@pattern]
               .reject { |item_path| File.directory?(item_path) }
               .map    { |item_path| Item.create(source_abspath, item_path) }
    end

    def each
      return enum_for(:each) unless block_given?

      @items.each do |item|
        yield item
      end
    end
  end
end
