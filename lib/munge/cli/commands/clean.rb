module Munge
  module Cli
    module Commands
      # This class is used by the CLI to build and calculate output
      class Clean
        def initialize(bootloader, dry_run:, reporter:, verbosity:, build_root: nil)
          destination_root = bootloader.root_path
          config = bootloader.config
          app = application(bootloader)
          destination = File.expand_path(build_root || config[:output_path], destination_root)
          @dry_run = dry_run

          io = Munge::Io::DryRun.new(Munge::Io::Filesystem.new)

          @runner =
            Munge::Runner.new(
              items: app.vomit(:items),
              router: app.vomit(:router),
              processor: app.vomit(:processor),
              io: io,
              reporter: Munge::Reporter.new(formatter: formatter("Silent"), verbosity: :silent),
              destination: destination,
              manager: Munge::WriteManager::All.new(io)
            )

          @output_path = File.expand_path(build_root || config[:output_path], destination_root)
        end

        def call
          io =
            if @dry_run
              Munge::Io::DryRun.new(Munge::Io::Filesystem.new)
            else
              Munge::Io::Filesystem.new
            end

          cleaner =
            Munge::Cleaner.new(
              path_to_clean: @output_path,
              paths_to_write: @runner.write,
              io: io
            )

          cleaner.delete
        end

        private

        def application(bootloader)
          bootstrap = bootloader.init

          bootstrap.app
        end

        def formatter(class_name)
          Munge::Formatters.const_get(class_name).new
        end
      end
    end
  end
end
