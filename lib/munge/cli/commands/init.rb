module Munge
  module Cli
    module Commands
      class Init
        include Thor::Base
        include Thor::Actions

        def self.source_root
          File.expand_path("../../../../../seeds", __FILE__)
        end

        def initialize(path)
          self.options = {}
          self.destination_root = File.expand_path(path)
        end

        def call
          directory(".", destination_root)

          inside(destination_root) do
            run_bundle("install")
            run_bundle("binstub munge")
          end
        end

        private

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
end
