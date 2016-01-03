require "sass"
Sass.load_paths << File.expand_path(system.config[:source])

tilt_transformer = Transformer::Tilt.new(system)
tilt_transformer.register(Munge::Helper::Find)
tilt_transformer.register(Munge::Helper::Link)
tilt_transformer.register(Munge::Helper::Rendering)

system.alterant.register(tilt_transformer)

system.router.register(Router::AutoAddExtension.new(keep_extensions: system.config[:keep_extensions]))
system.router.register(Router::Fingerprint.new(extensions: system.config[:keep_extensions]))
system.router.register(Router::IndexHtml.new(html_extensions: system.config[:text_extensions], index: system.config[:index]))
