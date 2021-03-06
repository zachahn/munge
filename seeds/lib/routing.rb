if ENV["MUNGE_ENV"] == "production"
  conglomerate.router.register(
    Munge::Router::Fingerprint.new(
      extensions: config[:router_fingerprint_extensions],
      separator: config[:router_fingeprint_separator]
    )
  )
end

conglomerate.router.register(
  Munge::Router::RemoveBasename.new(
    extensions: config[:router_remove_basename_original_extensions],
    basenames: config[:router_remove_basename_route_basenames],
    keep_explicit: config[:router_remove_basename_keep_explicit]
  )
)

conglomerate.router.register(
  Munge::Router::AddDirectoryIndex.new(
    extensions: config[:router_add_index_original_extensions],
    index: config[:router_add_index_basename]
  )
)

conglomerate.router.register(
  Munge::Router::AutoAddExtension.new(
    keep_extensions: config[:router_keep_extensions]
  )
)
