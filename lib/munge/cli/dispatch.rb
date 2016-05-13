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

        inside(path) do
          run_bundle("install")
          run_bundle("binstub munge")
        end
      end

      desc "build", "Build site"
      method_option :reporter,    desc: "Set reporter", default: "Default", type: :string
      method_option :dry_run,     desc: "Run without writing files", default: false, type: :boolean
      def build
        Commands::Build.new(bootloader, **symbolized_options, build_root: ENV["BUILD_ROOT"]).call
      end

      desc "view", "View built files"
      method_option :port, aliases: "-p", desc: "Set port", default: 7000, type: :numeric
      method_option :host, aliases: "-h", desc: "Set host", default: "0.0.0.0", type: :string
      def view
        Commands::View.new(bootloader, **symbolized_options, build_root: ENV["BUILD_ROOT"]).call
      end

      desc "server", "Run the development server"
      def server
        Commands::Server.new(bootloader).call
      end

      desc "version", "Print version"
      map %w(-v --version) => "version"
      def version
        puts "munge #{Munge::VERSION}"
      end

      private

      def bootloader
        Munge::Bootloader.new(root_path: destination_root)
      end

      def symbolized_options
        Munge::Util::SymbolHash.deep_convert(options)
      end

      def run_bundle(command)
        if Gem::Specification.find_all_by_name("bundler").any?
          say_status :run, "bundle #{command}"

          require "bundler"

          ::Bundler.with_clean_env do
            system("bundle #{command}")
          end
        end
      end
    end
  end
end
