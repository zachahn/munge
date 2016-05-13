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
        rescue Interrupt
          @listener.stop
        end

        private

        def listener
          require "listen"

          Listen.to(@bootloader.root_path) do
            system("munge build")
          end
        end
      end
    end
  end
end
