module Munge
  module Transformer
    class Tilt
      class Scope
        def initialize(layouts:,
                       global_data:,
                       source:,
                       router:)
          @global_data = global_data
          @layouts     = layouts
          @source      = source
          @router      = router
        end
      end
    end
  end
end
