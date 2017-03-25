module Munge
  module Cli
    # This class directs commandline flags to appropriate classes
    class Dispatch < Thor
      desc "init PATH", "Create new site at PATH"
      def init(path)
        Commands::Init.new(path).call
      end

      desc "build", "Build site"
      method_option :reporter, desc: "Set reporting formatter", default: "Default", type: :string
      method_option :dry_run, desc: "Run without writing files", default: false, type: :boolean
      method_option :verbosity, aliases: "-v", desc: "Preferred amount of output", enum: %w(all written silent), default: "written", type: :string
      def build
        production!

        Commands::Build.new(bootloader, **symbolized_options, build_root: ENV["BUILD_ROOT"]).call
      end

      desc "view", "View built files"
      method_option :port, aliases: "-p", desc: "Set port", default: 7000, type: :numeric
      method_option :host, aliases: "-h", desc: "Set host", default: "0.0.0.0", type: :string
      def view
        production!

        Commands::View.new(bootloader, **symbolized_options, build_root: ENV["BUILD_ROOT"]).call
      end

      desc "server", "Run the development server"
      method_option :livereload, desc: "Reload browser on update", default: Gem.loaded_specs.key?("reel"), type: :boolean
      method_option :port, aliases: "-p", desc: "Set port", default: 7000, type: :numeric
      method_option :host, aliases: "-h", desc: "Set host", default: "0.0.0.0", type: :string
      def server
        development!

        Commands::Server.new(bootloader, **symbolized_options).call
      end

      desc "update", "Use with caution: override local configs with pristine version (useful after bumping version in Gemfile)"
      def update
        development!

        Commands::Update.new(bootloader, current_working_directory).call
      end

      desc "version", "Print version (v#{Munge::VERSION})"
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
      rescue Munge::Errors::ConfigRbNotFound => e
        puts e.message
        exit
      end

      def symbolized_options
        Munge::Util::SymbolHash.deep_convert(options)
      end

      def production!
        ENV["MUNGE_ENV"] ||= "production"
      end

      def development!
        ENV["MUNGE_ENV"] ||= "development"
        ENV["BUILD_ROOT"] ||= "tmp/development-build"
      end
    end
  end
end
