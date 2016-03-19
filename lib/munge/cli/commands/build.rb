module Munge
  module Cli
    module Commands
      class Build
        def initialize(destination_root, config, options)
          @app = application(destination_root)
          @dry_run = options[:dry_run]
          reporter_class = Munge::Reporters.const_get(options[:reporter])

          runner =
            Munge::Runner.new(
              source: @app.vomit(:source),
              router: @app.vomit(:router),
              alterant: @app.vomit(:alterant),
              writer: writer,
              reporter: reporter_class.new,
              destination: File.expand_path(config[:output], destination_root)
            )

          runner.write
        end

        private

        def application(root_path)
          bootstrap = Munge::Bootstrap.new_from_dir(root_path: root_path)

          bootstrap.app
        end

        def writer
          if @dry_run
            Munge::Writers::Noop.new
          else
            Munge::Writers::Filesystem.new
          end
        end
      end
    end
  end
end
