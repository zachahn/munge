require "thor"

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
      Munge::Runner.write(config_path, rules_path)
    end

    desc "version", "Print version"
    def version
      puts "munge #{Munge::VERSION}"
    end

    private

    def config_path
      File.join(destination_root, "config.yml")
    end

    def rules_path
      File.join(destination_root, "rules.rb")
    end
  end
end
