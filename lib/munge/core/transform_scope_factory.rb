module Munge
  module Core
    class TransformScopeFactory
      def initialize(source_path:,
                     layouts_path:,
                     global_data:,
                     source:,
                     helper_container:,
                     router:)
        @source_path      = source_path
        @layouts_path     = layouts_path
        @global_data      = global_data
        @source           = source
        @helper_container = helper_container
        @router           = router
      end

      def create(load_helpers = true)
        scope = Munge::Transformer::Tilt::Scope.new(
          @source_path,
          @layouts_path,
          @global_data,
          @source,
          @router
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
