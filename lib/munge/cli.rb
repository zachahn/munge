require "thor"

module Munge
  class CLI < Thor
    desc "version", "Print version"
    def version
      puts "munge #{Munge::VERSION}"
    end
  end
end
