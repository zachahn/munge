module Munge
  module Cli
    module Commands
      class Update
        include Thor::Base
        include Thor::Actions

        def self.source_root
          File.expand_path("../../../../../seeds", __FILE__)
        end

        def initialize(bootloader, path)
          self.options = {}
          self.destination_root = File.expand_path(path)
        end

        def call
          directory("config", File.expand_path("config", destination_root))
          copy_file("setup.rb")
        end
      end
    end
  end
end
