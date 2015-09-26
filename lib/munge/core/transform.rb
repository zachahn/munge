module Munge
  module Core
    class Transform
      def initialize(source_path,
                     layouts_path,
                     global_data,
                     source)
        @scope_factory = Core::TransformScopeFactory.new(
          source_path,
          layouts_path,
          global_data,
          source,
          Munge::Helper
        )
      end

      def call(item)
        item.transforms
          .map { |name, args| [resolve_transformer(name), args] }
          .inject(item.content) do |content, params|
            transformer, args = params

            t = transformer.new(@scope_factory)

            t.call(item, content, *args)
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
