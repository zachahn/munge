if ENV["MUNGE_ENV"] == "production"
  system.router.register(
    Routers::Fingerprint.new(
      extensions: config[:bin_extensions] + config[:bintext_extensions],
      separator: config[:fingeprint_separator]
    ))
end

system.router.register(
  Routers::RemoveIndexBasename.new(
    html_extensions: config[:text_extensions],
    index: config[:index]
  ))

system.router.register(
  Routers::AddIndexHtml.new(
    html_extensions: config[:text_extensions],
    index: config[:index]
  ))

system.router.register(
  Routers::AutoAddExtension.new(
    keep_extensions: config[:bin_extensions] + config[:bintext_extensions]
  ))
