module Munge
  module Transformer
    class Tilt
      class Scope
        include Munge::Helper::Rendering

        def initialize(layouts_path, global_data)
          @global_data  = global_data
          @layouts_path = layouts_path
        end
      end
    end
  end
end
