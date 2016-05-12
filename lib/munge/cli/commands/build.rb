module Munge
  module Cli
    module Commands
      class Build
        def initialize(bootloader, dry_run:, reporter:, build_root: nil)
          destination_root = bootloader.root_path
          config           = bootloader.config
          app              = application(bootloader)
          destination      = File.expand_path(build_root || config[:output], destination_root)

          @runner =
            Munge::Runner.new(
              items: app.vomit(:items),
              router: app.vomit(:router),
              alterant: app.vomit(:alterant),
              writer: writer(dry_run),
              reporter: reporter(reporter),
              destination: destination
            )
        end

        def call
          @runner.write
        end

        private

        def application(bootloader)
          bootstrap = bootloader.init

          bootstrap.app
        end

        def writer(dry_run)
          if dry_run
            Munge::Writers::Noop.new
          else
            Munge::Writers::Filesystem.new
          end
        end

        def reporter(class_name)
          Munge::Reporters.const_get(class_name).new
        end
      end
    end
  end
end
