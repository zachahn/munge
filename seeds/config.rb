yml = YAML.safe_load(__end__)

# Path to content
config.source_path = "src"
# Path to layouts
config.layouts_path = "layouts"
# Path to output result directory
config.output_path = "dest"
# Path to global data file
config.data_path = "data.yml"

# Determines `item.text?` and `item.binary?` for items and layouts
# This can be useful avoid applying a transformation to an image
config.items_text_extensions = yml["text_extensions"] + yml["bintext_extensions"]
config.layouts_text_extensions = yml["text_extensions"] + yml["bintext_extensions"]

# Specify which extensions shouldn't be included as a part of `item.id`
config.items_ignore_extensions = yml["dynamic_extensions"]

# Specify which files require an asset fingerprint
config.router_fingerprint_extensions = yml["bin_extensions"] + yml["bintext_extensions"]

# Separator between basename and fingerprint hash
config.router_fingeprint_separator = "-"

# Remove basename from compiled _route_ if the basename is passed and original file has extension
config.router_remove_basename_original_extensions = %w(htm html)
config.router_remove_basename_route_basenames = %w(index)
config.router_remove_basename_keep_explicit = true

# Append basename to the _filepath_ if missing and if original file has extension
config.router_add_index_original_extensions = yml["text_extensions"]
config.router_add_index_basename = "index.html"

# Ensure that items with these extensions retains the extension, even if the route itself does not specify it
config.router_keep_extensions = yml["bin_extensions"] + yml["bintext_extensions"]

__END__
---
text_extensions:
  - html
  - htm
  - txt
  - md

bintext_extensions:
  - js
  - css
  - scss

bin_extensions:
  - gif
  - ico
  - jpg
  - jpeg
  - png
  - otf
  - ttf
  - eot
  - woff

dynamic_extensions:
  - erb
  - scss
  - md
