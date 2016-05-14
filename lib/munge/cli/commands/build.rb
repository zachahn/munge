module Munge
  module Cli
    module Commands
      class Build
        def initialize(bootloader, dry_run:, reporter:, verbosity:, build_root: nil)
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
              formatter: formatter(reporter),
              verbosity: verbosity.to_sym,
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

        def formatter(class_name)
          Munge::Formatters.const_get(class_name).new
        end
      end
    end
  end
end
