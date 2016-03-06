require "sass"
require_relative "sass/asset_urls"

def setup_sass_path!(*paths)
  Sass.load_paths << File.join(*paths)
end

def setup_sass_system!(system)
  Sass::Script::Functions.send(:define_method, :munge_system) do
    system
  end
end

def setup_sass_with_module!(asset_roots)
  Sass::Script::Functions.send(:include, asset_roots)
end
