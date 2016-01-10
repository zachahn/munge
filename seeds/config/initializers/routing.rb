system.router.register(Router::Fingerprint.new(extensions: system.config[:keep_extensions], separator: system.config[:fingeprint_separator]))
system.router.register(Router::RemoveIndexBasename.new(html_extensions: system.config[:text_extensions], index: system.config[:index]))
system.router.register(Router::AddIndexHtml.new(html_extensions: system.config[:text_extensions], index: system.config[:index]))
system.router.register(Router::AutoAddExtension.new(keep_extensions: system.config[:keep_extensions]))
