require_relative "tilt/scope"

module Munge
  module Transformer
    class Tilt
      def initialize(_source_path, layouts_path, global_data)
        @scope = Scope.new(layouts_path, global_data)
      end

      def call(item, content = nil, renderer = nil)
        if content.nil?
          @scope.render_with_layout(item, renderer)
        else
          @scope.render_with_layout(item, renderer) do
            content
          end
        end
      end
    end
  end
end
