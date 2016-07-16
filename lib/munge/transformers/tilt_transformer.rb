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
        scope = Scope.new(@system.clone, @demands)
        @registry.each { |helpers| scope.extend(helpers) }

        scope.render_with_layout(item, content_engines: renderer, content_override: content)
      end

      def register(helper)
        @registry.push(helper)
      end

      def demand(tilt_template, **options)
        @demands[tilt_template] = @demands[tilt_template].merge(options)
      end

      class Scope
        def initialize(system, tilt_options)
          @system = system
          @tilt_options = tilt_options
        end

        attr_reader :system
        attr_reader :tilt_options
      end
    end
  end
end
