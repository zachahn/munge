module Munge
  module Cli
    module Commands
      class Build
        def initialize(destination_root)
          Munge::Runner.write(destination_root)
        end
      end
    end
  end
end
