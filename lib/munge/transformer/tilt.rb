require_relative "tilt/scope"

module Munge
  module Transformer
    class Tilt
      def initialize(scope_factory)
        @scope = scope_factory.create
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
