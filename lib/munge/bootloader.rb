module Munge
  # This class is useful for loading the application.
  class Bootloader
    # @param root_path [String] Absolute path to munge directory
    def initialize(root_path:)
      @root_path = root_path
      @setup_path = File.join(root_path, "setup.rb")
      @rules_path = File.join(root_path, "rules.rb")

      config_path = File.join(root_path, "config.rb")
      @config = Munge::PreInit.new(config_path).config
    end

    attr_reader :root_path
    attr_reader :setup_path
    attr_reader :rules_path
    attr_reader :config
  end
end
