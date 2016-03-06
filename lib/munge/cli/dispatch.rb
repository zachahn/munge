require "thor"

module Munge
  module Cli
    class Dispatch < Thor
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
        require_relative "commands/build"
        Commands::Build.new(destination_root)
      end

      desc "view", "View built files"
      method_option :port, aliases: "-p", desc: "Set port", default: 7000, type: :numeric
      method_option :host, aliases: "-h", desc: "Set host", default: "0.0.0.0", type: :string
      def view
        require_relative "commands/view"
        Commands::View.new(options, config_path)
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
end