module Munge
  module Transformers
    class TiltTransformer
      def initialize(scope)
        @pristine_scope = scope
        @registry       = []
        @demands        = Hash.new { |hash, key| {} }
      end

      def name
        :tilt
      end

      def call(item, content = nil, renderer = nil)
        scope = @pristine_scope.dup
        scope.instance_variable_set :@renderer, @renderer
        dirty_scope = extend_with_helpers(scope)
        dirty_scope.instance_variable_set(:@tilt_options, @demands)
        dirty_scope.render_with_layout(item, content_engines: renderer, content_override: content)
      end

      def register(helper)
        @registry.push(helper)
      end

      def demand(tilt_template, **options)
        @demands[tilt_template] = @demands[tilt_template].merge(options)
      end

      private

      def extend_with_helpers(scope)
        @registry
          .inject(scope) { |a, e| a.extend(e) }
      end
    end
  end
end
