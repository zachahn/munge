module Munge
  module Cli
    class Dispatch < Thor
      desc "init PATH", "Create new site at PATH"
      def init(path)
        Commands::Init.new(path).call
      end

      desc "build", "Build site"
      method_option :reporter,    desc: "Set reporting formatter", default: "Default", type: :string
      method_option :dry_run,     desc: "Run without writing files", default: false, type: :boolean
      method_option :verbosity, aliases: "-v", desc: "Preferred amount of output", enum: %w(all written silent), default: "written", type: :string
      def build
        ENV["MUNGE_ENV"] ||= "production"

        Commands::Build.new(bootloader, **symbolized_options, build_root: ENV["BUILD_ROOT"]).call
      end

      desc "view", "View built files"
      method_option :port, aliases: "-p", desc: "Set port", default: 7000, type: :numeric
      method_option :host, aliases: "-h", desc: "Set host", default: "0.0.0.0", type: :string
      def view
        ENV["MUNGE_ENV"] ||= "production"

        Commands::View.new(bootloader, **symbolized_options, build_root: ENV["BUILD_ROOT"]).call
      end

      desc "server", "Run the development server"
      def server
        ENV["MUNGE_ENV"]  ||= "development"
        ENV["BUILD_ROOT"] ||= "tmp/development-build"

        Commands::Server.new(bootloader).call
      end

      desc "version", "Print version"
      map %w(-v --version) => "version"
      def version
        puts "munge #{Munge::VERSION}"
      end

      private

      def current_working_directory
        File.expand_path("")
      end

      def bootloader
        Munge::Bootloader.new(root_path: current_working_directory)
      end

      def symbolized_options
        Munge::Util::SymbolHash.deep_convert(options)
      end
    end
  end
end
