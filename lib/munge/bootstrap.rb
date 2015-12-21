module Munge
  class Bootstrap
    def self.new_from_fs(root_path:,
                         config_path:,
                         setup_path:,
                         rules_path:)
      new(
        root_path: root_path,
        config: read_config(config_path),
        setup_string: File.read(setup_path),
        setup_path: setup_path,
        rules_string: File.read(rules_path),
        rules_path: rules_path
      )
    end

    def self.read_config(config_path)
      Munge::Core::Config.new(config_path)
    end

    def initialize(root_path:,
                   config:,
                   setup_string:,
                   rules_string:,
                   setup_path:,
                   rules_path:)
      @app =
        Munge::Application.new(
          Munge::System.new(root_path, config)
        )

      binding.eval(setup_string, setup_path)
      binding.eval(rules_string, rules_path)
    end

    attr_reader :app
  end
end
