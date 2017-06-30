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
        view_scope = new_view_scope
        view_scope.extend(Munge::Helper::DefineModule.new(:instance, item.frontmatter))

        if item.layout
          layout_item = view_scope.layouts[item.layout]

          transform_layout(layout_item, view_scope) do
            transform_item(item, view_scope)
          end
        else
          transform_item(item, view_scope)
        end
      end

      def transform_item(item, view_scope)
        renderer =
          @fixer_upper.renderer(
            filename: item.filename,
            content: item.content,
            view_scope: view_scope,
            engines: engines_for(item)
          )

        renderer.call
      end

      def transform_layout(layout_item, view_scope, &block)
        renderer =
          @fixer_upper.renderer(
            filename: "(layout) #{layout_item.filename}",
            content: layout_item.content,
            view_scope: view_scope,
            engines: engines_for(layout_item),
            block: block
          )

        renderer.call
      end

      # everything below should be considered private API

      attr_reader :fixer_upper

      def new_view_scope
        scope =
          @scope_modules.reduce(Object.new) do |scope, mod|
            scope.extend(mod)
            scope
          end

        scope.extend(Munge::Helper::DefineModule.new(:current_view_scope, scope))

        scope
      end

      def engines_for(item, engine_overrides = [])
        transforms = resolved_engines(item.transforms, item.extensions)
        overrides = resolved_engines(engine_overrides, item.extensions)

        if overrides.empty?
          transforms
        else
          overrides
        end
      end

      private

      def resolved_engines(engines, extensions)
        safe_engines = [engines].flatten.compact

        safe_engines.flat_map do |engine|
          if engine == :use_extensions
            extensions.reverse
          else
            engine
          end
        end
      end
    end
  end
end
