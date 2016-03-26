require "thor"

module Munge
  module Cli
    class Dispatch < Thor
      include Thor::Actions

      def self.source_root
        File.expand_path("../../../../seeds", __FILE__)
      end

      desc "init PATH", "Create new site at PATH"
      def init(path)
        directory ".", path
      end

      desc "build", "Build in current directory"
      method_option :reporter, desc: "Set reporter", default: "Default", type: :string
      method_option :dry_run, desc: "Run without writing files", default: false, type: :boolean
      def build
        Commands::Build.new(destination_root, loaded_config, options)
      end

      desc "view", "View built files"
      method_option :port, aliases: "-p", desc: "Set port", default: 7000, type: :numeric
      method_option :host, aliases: "-h", desc: "Set host", default: "0.0.0.0", type: :string
      def view
        Commands::View.new(loaded_config, options)
      end

      desc "version", "Print version"
      map %w(-v --version) => "version"
      def version
        puts "munge #{Munge::VERSION}"
      end

      private

      def loaded_config
        Munge::Util::Config.read(config_path)
      end

      def config_path
        File.join(destination_root, "config.yml")
      end
    end
  end
end
