module Munge
  module Transformer
    class Base
      def self.call(item, scope = nil, info = nil, *args)
        transformer = new(item, scope, info)
        transformer.call(*args)
      end

      def initialize(item, scope, data)
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
