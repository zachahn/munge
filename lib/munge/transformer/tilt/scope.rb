module Munge
  module Transformer
    class Tilt
      class Scope
        def initialize(source_path:,
                       layouts_path:,
                       global_data:,
                       source:,
                       router:)
          @source_path  = source_path
          @layouts_path = layouts_path
          @global_data  = global_data
          @source       = source
          @router       = router
        end
      end
    end
  end
end
