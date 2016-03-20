module Munge
  class Bootstrap
    class << self
      def new_from_dir(root_path:)
        new_from_fs(
          root_path: root_path,
          config_path: config_path(root_path),
          setup_path: setup_path(root_path),
          rules_path: rules_path(root_path)
        )
      end

      def new_from_fs(root_path:,
                      config_path:,
                      setup_path:,
                      rules_path:)
        new(
          root_path: root_path,
          config: read_config(config_path),
          setup_path: setup_path,
          rules_path: rules_path
        )
      end

      private

      def read_config(config_path)
        Munge::Util::Config.read(config_path)
      end

      def config_path(root_path)
        File.join(root_path, "config.yml")
      end

      def setup_path(root_path)
        File.join(root_path, "setup.rb")
      end

      def rules_path(root_path)
        File.join(root_path, "rules.rb")
      end
    end

    def initialize(root_path:,
                   config:,
                   setup_path:,
                   rules_path:)
      @setup_path = setup_path
      @rules_path = rules_path
      @binding    = binding

      system = Munge::System.new(root_path, config)

      import(setup_path)

      @app = Munge::Application.new(system)

      import(rules_path)
    end

    def root_path
      File.dirname(@setup_path)
    end

    def config_path
      File.join(root_path, "config")
    end

    def import(file_path)
      absolute_file_path = File.expand_path(file_path, root_path)
      contents           = File.read(absolute_file_path)
      @binding.eval(contents, absolute_file_path)
    end

    attr_reader :app
  end
end
