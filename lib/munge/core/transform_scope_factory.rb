module Munge
  module Core
    class TransformScopeFactory
      def initialize(layouts:,
                     global_data:,
                     source:,
                     helper_container:,
                     router:)
        @layouts          = layouts
        @global_data      = global_data
        @source           = source
        @helper_container = helper_container
        @router           = router
      end

      def create(load_helpers = true)
        scope = Munge::Transformer::Tilt::Scope.new(
          layouts:     @layouts,
          global_data: @global_data,
          source:      @source,
          router:      @router
        )

        if load_helpers
          extend_with_helpers(scope)
        end

        scope
      end

      private

      def extend_with_helpers(scope)
        Munge::Helper.constants
          .map  { |sym| @helper_container.const_get(sym) }
          .each { |helper| scope.extend(helper) }

        scope
      end
    end
  end
end
