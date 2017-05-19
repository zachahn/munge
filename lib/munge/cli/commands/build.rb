module Munge
  module Cli
    module Commands
      # This class is used by the CLI to build and calculate output
      class Build
        # @param bootloader [Munge::Bootloader]
        # @param dry_run [true, false]
        # @param reporter [Munge::Reporters]
        # @param build_root [String, nil]
        def initialize(bootloader, dry_run:, reporter:, verbosity:, build_root: nil)
          destination_root = bootloader.root_path
          config = bootloader.config
          app = application(bootloader)
          destination = File.expand_path(build_root || config[:output_path], destination_root)

          vfs = new_vfs(dry_run, destination)

          @runner =
            Munge::Runner.new(
              items: app.vomit(:items),
              router: app.vomit(:router),
              processor: app.vomit(:processor),
              reporter: Munge::Reporter.new(formatter: new_formatter(reporter), verbosity: verbosity.to_sym),
              manager: Munge::WriteManager::OnlyNeeded.new(vfs),
              vfs: vfs
            )
        end

        # @return [Array<String>] list of updated items routes
        def call
          @runner.write
        end

        private

        def application(bootloader)
          bootstrap = bootloader.init

          bootstrap.app
        end

        def new_vfs(dry_run, destination)
          fs = Munge::Vfs::Filesystem.new(destination)

          if dry_run
            Munge::Vfs::DryRun.new(fs)
          else
            fs
          end
        end

        def new_formatter(class_name)
          Munge::Formatter.const_get(class_name).new
        end
      end
    end
  end
end
