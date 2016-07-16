module Munge
  module Transformers
    class TiltTransformer
      def initialize(system)
        @system = system
        @registry = []
        @demands = Hash.new { Hash.new }
      end

      def name
        :tilt
      end

      def call(item, content = nil, renderer = nil)
        system = @system.clone
        demands = @demands

        scope = Object.new
        @registry.each { |helpers| scope.extend(helpers) }
        scope.define_singleton_method(:system) { system }
        scope.define_singleton_method(:tilt_options) { demands }

        scope.render_with_layout(item, content_engines: renderer, content_override: content)
      end

      def register(helper)
        @registry.push(helper)
      end

      def demand(tilt_template, **options)
        @demands[tilt_template] = @demands[tilt_template].merge(options)
      end
    end
  end
end
