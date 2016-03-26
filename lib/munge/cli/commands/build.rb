module Munge
  module Cli
    module Commands
      class Build
        def initialize(destination_root, config, dry_run:, reporter:)
          @app = application(destination_root)

          runner =
            Munge::Runner.new(
              items: @app.vomit(:items),
              router: @app.vomit(:router),
              alterant: @app.vomit(:alterant),
              writer: writer(dry_run),
              reporter: reporter(reporter),
              destination: File.expand_path(config[:output], destination_root)
            )

          runner.write
        end

        private

        def application(root_path)
          bootloader = Munge::Bootloader.new(root_path: root_path)
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
