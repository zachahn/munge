module Munge
  module Transformer
    class Tilt
      class Scope
        include Munge::Helper::Rendering

        def initialize(source_path,
                       layouts_path,
                       global_data,
                       source)
          @source_path      = source_path
          @layouts_path     = layouts_path
          @global_data      = global_data
          @source           = source
        end
      end
    end
  end
end
