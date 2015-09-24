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

    desc "version", "Print version"
    def version
      puts "munge #{Munge::VERSION}"
    end
  end
end
