module Sass::Script::Functions
  def stringify_string(stringish)
    if stringish.instance_of?(::String)
      stringish
    else
      stringish.value
    end
  end

  def asset_route_helper(root, basename)
    basename_string = stringify_string(basename)

    item = system.source["#{root}/#{basename_string}"]
    r = system.router.route(item)

    quoted_string(r)
  end

  def font_route(basename)
    asset_route_helper(fonts_root, basename)
  end

  def font_url(basename)
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

  def image_url(basename)
    img_route = asset_route_helper(images_root, basename)
    unquoted_string("url(#{img_route})")
  end
end