module Munge
  module Transformer
    class Tilt < Base
      def call(content, renderer = nil)
        if renderer.nil?
          auto_transform(content)
        else
          manual_transform(content, renderer)
        end
      end

      private

      def auto_transform(content)
        ::Tilt
          .templates_for(item.relpath)
          .inject(content) do |output, engine|
            template = engine.new { output }
            template.render(scope, merged_data)
          end
      end

      def manual_transform(content, renderer)
        template = ::Tilt[renderer].new { content }
        template.render(scope, merged_data)
      end
    end
  end
end
