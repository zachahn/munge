module Munge
  module Utility
    class Transform
      def initialize(scope = nil, data = {})
        @scope = scope
        @data  = data
      end

      def call(item)
        item.transforms
          .map { |name, args| [resolve_transformer(name), args] }
          .inject(item.content) do |content, params|
            t, args = params

            t.call(item, content, @scope, @data, *args)
          end
      end

      def resolve_transformer(identifier)
        resolver = proc do |name|
          if Munge::Transformer.constants.include?(name)
            return Munge::Transformer.const_get(name)
          end
        end

        resolver.call(identifier.to_sym)

        resolver.call(underscore_to_camel(identifier.to_s).to_sym)
      end

      private

      def underscore_to_camel(string)
        string
          .split("_")
          .map(&:capitalize)
          .join("")
      end
    end
  end
end
