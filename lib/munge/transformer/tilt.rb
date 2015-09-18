module Munge
  module Transformer
    class Tilt < Base
      def call(renderer = nil)
        if renderer.nil?
          auto_transform
        else
          manual_transform(renderer)
        end
      end

      private

      def auto_transform
        ::Tilt
          .templates_for(item.relpath)
          .inject(item.content) do |output, engine|
            template = engine.new { output }
            template.render(nil, item.frontmatter.merge(data))
          end
      end

      def manual_transform(renderer)
        template = ::Tilt[renderer].new { item.content }
        template.render(scope, data)
      end
    end
  end
end
