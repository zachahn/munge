yml = YAML.load(__end__)

config.source = "src"
config.output = "dest"
config.data = "data.yml"
config.layouts = "layouts"
config.index = "index.html"
config.fingeprint_separator = "-"
config.text_extensions = yml["text_extensions"]
config.bintext_extensions = yml["bintext_extensions"]
config.bin_extensions = yml["bin_extensions"]
config.dynamic_extensions = yml["dynamic_extensions"]

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
