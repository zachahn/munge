module Munge
  module Cli
    module Commands
      class Server
        def initialize(bootloader, livereload:)
          @bootloader = bootloader
          @listener = listener
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

          system("munge view")
        rescue Interrupt
          @listener.stop
        end

        private

        def listener
          require "listen"

          listen = Listen.to(@bootloader.root_path) do
            built_files = munge_build

            @livereload.notify_changes(files: built_files)

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
          bootloader =
            Munge::Bootloader.new(root_path: @bootloader.root_path)

          build_command =
            Munge::Cli::Commands::Build.new(
              bootloader,
              dry_run: false,
              reporter: "Default",
              verbosity: "written",
              build_root: ENV["BUILD_ROOT"]
            )

          build_command.call
        end
      end
    end
  end
end
