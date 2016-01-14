module Sass::Script::Functions
  include AssetRoots
end

Sass::Script::Functions.send(:define_method, :stringify_string) do |stringish|
  if stringish.instance_of?(::String)
    stringish
  else
    stringish.value
  end
end

Sass::Script::Functions.send(:define_method, :route) do |id_ruby_string|
  item = system.source[id_ruby_string]
  r = system.router.route(item)

  quoted_string(r)
end

Sass::Script::Functions.send(:define_method, :asset_route_helper) do |root, basename|
  basename_string = stringify_string(basename)

  route("#{root}/#{basename_string}")
end

Sass::Script::Functions.send(:define_method, :font_route) do |basename|
  asset_route_helper(fonts_root, basename)
end

Sass::Script::Functions.send(:define_method, :image_route) do |basename|
  asset_route_helper(images_root, basename)
end

Sass::Script::Functions.send(:define_method, :font_url) do |basename|
  basename_string = stringify_string(basename)

  if basename_string.include?("?")
    basename_parts = basename_string.split("?")

    base = "#{basename_parts[0]}"
    qs   = "?#{basename_parts[1]}"

    path_to_font = quoted_string(font_route(base).value + qs)

    unquoted_string("url(#{path_to_font})")
  else
    unquoted_string("url(#{font_route(basename)})")
  end
end

Sass::Script::Functions.send(:define_method, :image_url) do |basename|
  img_route = image_route(basename)
  unquoted_string("url(#{img_route})")
end
