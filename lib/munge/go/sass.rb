require "sass"
require_relative "sass/asset_urls"

module Munge
  module Go
    module_function

    # Appends a path to Sass's load paths. To append multiple paths, call the
    # function multiple times.
    #
    # @param paths [Array<String>, String] path or components of path
    # @return [void]
    def add_sass_load_path!(*paths)
      Sass.load_paths << File.join(*paths)
    end

    # Sets {Munge::Conglomerate} for use with plugins
    #
    # @param system [Munge::Conglomerate]
    # @return [void]
    def set_sass_system!(system)
      Sass::Script::Functions.send(:define_method, :system) do
        system
      end
    end

    # Includes methods into Sass functions scope
    #
    # @param asset_roots [Module]
    # @return [void]
    def add_sass_functions!(asset_roots)
      Sass::Script::Functions.send(:include, asset_roots)
    end
  end
end
