module Munge
  module Cli
    module Commands
      class Server
        def initialize(bootloader, livereload:, host:, port:)
          @bootloader = bootloader
          @listener = listener
          @view_host = host
          @view_port = port
          @livereload =
            if livereload
              if Gem.loaded_specs.key?("reel")
                Munge::Extras::Livereload::Main.new(true)
              else
                STDERR.puts "Gem `reel` is not installed. Check that your Ruby version is compatible"
                Munge::Extras::Livereload::Main.new(false)
              end
            else
              Munge::Extras::Livereload::Main.new(false)
            end
        end

        def call
          @listener.start

          munge_build

          munge_view
        rescue Interrupt
          @listener.stop
        end

        private

        def listener
          require "listen"

          listen = Listen.to(@bootloader.root_path) do
            begin
              built_files = munge_build

              @livereload.notify_changes(files: built_files)
            rescue => e
              puts "ERROR: #{e.message}"
              puts e.backtrace.map { |line| "\t" + line }.join("\n")
            end

            GC.start
          end

          ignore(listen, ".sass-cache")
          ignore(listen, ENV["BUILD_ROOT"])
          ignore(listen, @bootloader.config[:output_path])

          listen
        end

        def ignore(listener, pattern)
          if pattern
            listener.ignore(/^#{Regexp.escape(pattern)}/)
          end
        end

        def munge_build
          build_command =
            Munge::Cli::Commands::Build.new(
              new_bootloader,
              dry_run: false,
              reporter: "Default",
              verbosity: "written",
              build_root: ENV["BUILD_ROOT"]
            )

          build_command.call
        end

        def munge_view
          view_command =
            Munge::Cli::Commands::View.new(
              new_bootloader,
              host: @view_host,
              port: @view_port,
              build_root: ENV["BUILD_ROOT"]
            )

          view_command.call
        end

        def new_bootloader
          Munge::Bootloader.new(root_path: @bootloader.root_path)
        end
      end
    end
  end
end
