module Munge
  class System
    class Processor
      def initialize
        @registry = {}
      end

      def register(transformer)
        register_manually(transformer.name, transformer)
      end

      # name should be snake_case Symbol
      def register_manually(name, transformer)
        if @registry.key?(name)
          raise "already registered transformer `#{name}`"
        else
          @registry[name] = transformer
        end
      end

      def transform(item)
        item.transforms
          .map { |name, args| [get_transformer(name), args] }
          .reduce(item.content) do |content, params|
            transformer, args = params

            transformer.call(item, content, *args)
          end
      end

      private

      def get_transformer(name)
        if @registry.key?(name)
          @registry[name]
        else
          raise "transformer `#{name}` is not installed"
        end
      end
    end
  end
end
