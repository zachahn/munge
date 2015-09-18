module Munge
  module Transformer
    class Base
      def self.call(item, content, scope = nil, data = {}, *args)
        transformer = new(item, scope, data)
        transformer.call(content, *args)
      end

      def initialize(item, scope = nil, data = {})
        @item  = item
        @scope = scope
        @data  = data
      end

      attr_reader :item, :scope, :data

      def merged_data
        item.frontmatter.merge(data)
      end
    end
  end
end
