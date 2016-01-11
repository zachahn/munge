system.router.register(
  Router::Fingerprint.new(
    extensions: config[:keep_extensions],
    separator: config[:fingeprint_separator]
  ))
system.router.register(
  Router::RemoveIndexBasename.new(
    html_extensions: config[:text_extensions],
    index: config[:index]
  ))
system.router.register(
  Router::AddIndexHtml.new(
    html_extensions: config[:text_extensions],
    index: config[:index]
  ))
system.router.register(
  Router::AutoAddExtension.new(
    keep_extensions: config[:keep_extensions],
  ))
