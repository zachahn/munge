require "sass"
require_relative "sass/asset_urls"

module Munge
  module Go
    module_function

    def add_sass_load_path!(*paths)
      Sass.load_paths << File.join(*paths)
    end

    # rubocop:disable Style/AccessorMethodName
    def set_sass_system!(system)
      Sass::Script::Functions.send(:define_method, :system) do
        system
      end
    end
    # rubocop:enable Style/AccessorMethodName

    def add_sass_functions!(asset_roots)
      Sass::Script::Functions.send(:include, asset_roots)
    end
  end
end
