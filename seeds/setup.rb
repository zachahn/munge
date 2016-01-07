require "sass"
Sass.load_paths << File.expand_path(system.config[:source], File.dirname(__FILE__))

tilt_transformer = Transformer::Tilt.new(system)
tilt_transformer.register(Munge::Helper::Capture)
tilt_transformer.register(Munge::Helper::Find)
tilt_transformer.register(Munge::Helper::Link)
tilt_transformer.register(Munge::Helper::Rendering)

system.alterant.register(tilt_transformer)

system.router.register(Router::Fingerprint.new(extensions: system.config[:keep_extensions], separator: system.config[:fingeprint_separator]))
system.router.register(Router::RemoveIndexBasename.new(html_extensions: system.config[:text_extensions], index: system.config[:index]))
system.router.register(Router::AddIndexHtml.new(html_extensions: system.config[:text_extensions], index: system.config[:index]))
system.router.register(Router::AutoAddExtension.new(keep_extensions: system.config[:keep_extensions]))
