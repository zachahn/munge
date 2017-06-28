module Munge
  class System
    class Processor
      def initialize
        @fixer_upper = FixerUpper.new
        @scope_modules = []
      end

      def register(*names, to:, with_options: {})
        @fixer_upper.register(*names, engine: to)
      end

      def register_tilt(*names, to:, with_options: {})
        @fixer_upper.register_tilt(*names, engine: to, options: with_options)
      end

      def include(mod)
        @scope_modules.push(mod)
      end

      # Transforms the given item's content
      #
      # @param item [Item]
      def transform(item)
        renderer =
          @fixer_upper.renderer(
            filename: item.filename,
            content: item.content,
            view_scope: view_scope,
            engines: engines_for(item)
          )

        renderer.call
      end

      private

      def view_scope
        @scope_modules.reduce(Object.new) do |scope, mod|
          scope.extend(mod)
          scope
        end
      end

      def engines_for(item)
        if item.transforms.any?
          item.transforms.reverse
        else
          nil
        end
      end
    end
  end
end
