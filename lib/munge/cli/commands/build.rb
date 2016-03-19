module Munge
  module Cli
    module Commands
      class Build
        def initialize(destination_root, options)
          app = application(destination_root)
          reporter_class = Munge::Reporters.const_get(options[:reporter])

          runner =
            Munge::Runner.new(
              source: app.vomit(:source),
              router: app.vomit(:router),
              alterant: app.vomit(:alterant),
              writer: app.vomit(:writer),
              reporter: reporter_class.new
            )

          runner.write
        end

        private

        def application(root_path)
          bootstrap = Munge::Bootstrap.new_from_dir(root_path: root_path)

          bootstrap.app
        end
      end
    end
  end
end
