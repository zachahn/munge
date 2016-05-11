require "listen"

module Munge
  module Cli
    module Commands
      class Server
        def initialize(bootloader)
          @bootloader = bootloader
          @listener   = listener
        end

        def call
          @listener.start

          Dir.chdir(@bootloader.root_path) do
            system("munge view")
          end
        end

        private

        def listener
          Listen.to(@bootloader.root_path) do |modified, added, removed|
            Dir.chdir(@bootloader.root_path) do
              system("munge build")
            end
          end
        end
      end
    end
  end
end
