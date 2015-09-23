module Munge
  module Transformer
    class Tilt
      def initialize(_source_path, layouts_dir, global_data)
        @scope = TiltItemRenderer.new(layouts_dir, global_data)
      end

      def call(item, content = nil, renderer = nil)
        if content.nil?
          @scope.render(item, renderer)
        else
          @scope.render(item, renderer) do
            content
          end
        end
      end
    end
  end
end
