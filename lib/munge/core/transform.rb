module Munge
  module Core
    class Transform
      def initialize(layouts:,
                     global_data:,
                     source:,
                     router:)
        @scope_factory = Core::TransformScopeFactory.new(
          layouts: layouts,
          global_data: global_data,
          source: source,
          helper_container: Munge::Helper,
          router: router
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
