module Munge
  class System
    class Processor
      def initialize
        @registry = {}
      end

      # Register tranformer
      #
      # @see Munge::Transformer::Tilt
      def register(transformer)
        register_manually(transformer.name, transformer)
      end

      # Register transformer manually
      #
      # @see Munge::Transformer::Tilt
      # @param name [Symbol] Snake case name
      # @param transformer [#call]
      def register_manually(name, transformer)
        if @registry.key?(name)
          raise Errors::DuplicateTransformerError, name
        else
          @registry[name] = transformer
        end
      end

      # Transforms the given item's content
      #
      # @param item [Item]
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
          raise Errors::TransformerNotFoundError, name
        end
      end
    end
  end
end
