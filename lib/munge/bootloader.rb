module Munge
  class Bootloader
    def initialize(root_path:)
      @root_path   = root_path
      @config_path = File.join(root_path, "config.yml")
      @setup_path  = File.join(root_path, "setup.rb")
      @rules_path  = File.join(root_path, "rules.rb")
    end

    def config
      Munge::Util::Config.read(@config_path)
    end

    def init
      Bootstrap.new(
        root_path: @root_path,
        config: config,
        setup_path: @setup_path,
        rules_path: @rules_path
      )
    end
  end
end
