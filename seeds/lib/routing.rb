if ENV["MUNGE_ENV"] == "production"
  system.router.register(
    Routers::Fingerprint.new(
      extensions: config[:router_fingerprint_extensions],
      separator: config[:router_fingeprint_separator]
    )
  )
end

system.router.register(
  Routers::RemoveIndexBasename.new(
    html_extensions: config[:router_remove_basename_extensions],
    index: config[:router_remove_basename_basename]
  )
)

system.router.register(
  Routers::AddIndexHtml.new(
    html_extensions: config[:router_add_index_html],
    index: config[:router_add_index_index]
  )
)

system.router.register(
  Routers::AutoAddExtension.new(
    keep_extensions: config[:router_keep_extensions]
  )
)
