require "sass"
require_relative "sass/asset_urls"

module Munge
  module Go
    module_function

    def add_sass_load_path!(*paths)
      Sass.load_paths << File.join(*paths)
    end

    def set_sass_system!(system)
      Sass::Script::Functions.send(:define_method, :munge_system) do
        system
      end
    end

    def add_sass_functions!(asset_roots)
      Sass::Script::Functions.send(:include, asset_roots)
    end
  end
end
