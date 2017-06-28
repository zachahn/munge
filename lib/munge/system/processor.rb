module Munge
  class System
    class Processor
      def initialize
        @fixer_upper = FixerUpper.new
      end

      def register(*names, to:, with_options: {})
        @fixer_upper.register(*names, engine: to)
      end

      def register_tilt(*names, to:, with_options: {})
        @fixer_upper.register_tilt(*names, engine: to, options: with_options)
      end

      # Transforms the given item's content
      #
      # @param item [Item]
      def transform(item)
        engines =
          if item.transforms.any?
            item.transforms.reverse
          else
            nil
          end

        renderer =
          @fixer_upper.renderer(
            filename: item.filename,
            content: item.content,
            view_scope: Object.new,
            engines: engines
          )

        renderer.call
      end
    end
  end
end
