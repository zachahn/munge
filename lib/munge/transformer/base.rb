module Munge
  module Transformer
    class Base
      def self.call(item, scope = nil, data = nil, *args)
        transformer = new(item, scope, data)
        transformer.call(*args)
      end

      def initialize(item, scope = nil, data = nil)
        @item  = item
        @scope = scope
        @data  = data
      end

      attr_reader :item, :scope

      def data
        @data.merge(@item.frontmatter)
      end
    end
  end
end
