module Munge
  module Cli
    module Commands
      # This class is used by the CLI to build and calculate output
      class Clean
        def initialize(bootloader, dry_run:, reporter:, verbosity:, build_root: nil)
          destination_root = bootloader.root_path
          config = bootloader.config
          destination = File.expand_path(build_root || config[:output_path], destination_root)

          memory = Munge::Vfs::Memory.new
          vfs = new_vfs(dry_run, destination)

          loader = Munge::Load.new(bootloader.root_path)

          @runner =
            loader.app do |_application, system|
              Munge::Function::Write.new(
                system: system,
                reporter: Munge::Reporter.new(formatter: formatter("Silent"), verbosity: :silent),
                manager: Munge::WriteManager::All.new(memory),
                destination: memory
              ).call

              Munge::Function::Clean.new(
                memory: memory,
                destination: vfs
              )
            end

          @output_path = File.expand_path(build_root || config[:output_path], destination_root)
        end

        def call
          @runner.call
        end

        private

        def formatter(class_name)
          Munge::Formatter.const_get(class_name).new
        end

        def new_vfs(dry_run, destination)
          fs = Munge::Vfs::Filesystem.new(destination)

          if dry_run
            Munge::Vfs::DryRun.new(fs)
          else
            fs
          end
        end
      end
    end
  end
end
