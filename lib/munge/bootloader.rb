module Munge
  # This class is useful for loading the application.
  class Bootloader
    # @param root_path [String] Absolute path to munge directory
    def initialize(root_path:)
      @root_path   = root_path
      @config_path = File.join(root_path, "config.yml")
      @setup_path  = File.join(root_path, "setup.rb")
      @rules_path  = File.join(root_path, "rules.rb")
      @config      = Munge::Util::Config.read(@config_path)
    end

    # @return [Munge::Init]
    def init
      @init ||=
        Init.new(
          root_path: @root_path,
          config: @config,
          setup_path: @setup_path,
          rules_path: @rules_path
        )
    end

    attr_reader :root_path
    attr_reader :config_path
    attr_reader :setup_path
    attr_reader :rules_path
    attr_reader :config
  end
end
