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
        scope.instance_variable_set :@renderer, @renderer
        dirty_scope = extend_with_helpers(scope)
        dirty_scope.render_with_layout(item, content_engines: renderer, content_override: content)
      end

      private

      def extend_with_helpers(scope)
        Munge::Helper.constants
          .map  { |sym| Munge::Helper.const_get(sym) }
          .inject(scope) { |a, e| a.extend(e) }
      end
    end
  end
end
