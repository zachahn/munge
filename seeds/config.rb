yml = YAML.load(__end__)

config.source_path = "src"
config.output_path = "dest"
config.data_path = "data.yml"
config.layouts_path = "layouts"

config.items_text_extensions = yml["text_extensions"] + yml["bintext_extensions"]
config.items_ignore_extensions = yml["dynamic_extensions"]
config.layouts_text_extensions = yml["text_extensions"] + yml["bintext_extensions"]

config.router_fingerprint_extensions = yml["bin_extensions"] + yml["bintext_extensions"]
config.router_fingeprint_separator = "-"
config.router_remove_basename_original_extensions = %w(htm html)
config.router_remove_basename_route_basenames = %w(index)
config.router_remove_basename_keep_explicit = true
config.router_add_index_original_extensions = yml["text_extensions"]
config.router_add_index_basename = "index.html"
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
