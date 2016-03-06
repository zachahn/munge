module Munge
  class System
    class Alterant
      def initialize
        @registry = {}
      end

      def register(transformer)
        register_manually(transformer.name, transformer)
      end

      # name should be snake_case Symbol
      def register_manually(name, transformer)
        if @registry.key?(name)
          fail "already registered transformer `#{name}`"
        else
          @registry[name] = transformer
        end
      end

      def transform(item)
        item.transforms
          .map { |name, args| [get_transformer(name), args] }
          .inject(item.content) do |content, params|
            transformer, args = params

            transformer.call(item, content, *args)
          end
      end

      private

      def get_transformer(name)
        if @registry.key?(name)
          @registry[name]
        else
          fail "transformer `#{name}` is not installed"
        end
      end
    end
  end
end