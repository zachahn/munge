require_relative "tilt/scope"

module Munge
  module Transformer
    class Tilt
      def initialize(scope_factory)
        @scope = scope_factory.create
      end

      def call(item, content = nil, renderer = nil)
        @scope.render_with_layout(item, content_engines: renderer, content_override: content)
      end
    end
  end
end
