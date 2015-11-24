require_relative "tilt/scope"

module Munge
  module Transformer
    class Tilt
      def initialize(scope)
        @pristine_scope = scope
      end

      def name
        :tilt
      end

      def call(item, content = nil, renderer = nil)
        scope = @pristine_scope.dup
        dirty_scope = extend_with_helpers(scope)
        dirty_scope.render_with_layout(item, content_engines: renderer, content_override: content)
      end

      private

      def extend_with_helpers(scope)
        Munge::Helper.constants
          .map  { |sym| Munge::Helper.const_get(sym) }
          .inject(scope) { |scope, helper| scope.extend(helper) }
      end
    end
  end
end
