require "thor"
require "munge/runner"

module Munge
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path("../../../seeds", __FILE__)
    end

    desc "init PATH", "Create new site at PATH"
    def init(path)
      directory ".", path
    end

    desc "build", "Build in current directory"
    def build
      config_path = File.join(destination_root, "config.yml")
      rules_path  = File.join(destination_root, "rules.rb")

      Munge::Runner.write(config_path, rules_path)
    end

    desc "version", "Print version"
    def version
      puts "munge #{Munge::VERSION}"
    end
  end
end
