if ENV["MUNGE_ENV"] == "production"
  system.router.register(
    Router::Fingerprint.new(
      extensions: config[:router_fingerprint_extensions],
      separator: config[:router_fingeprint_separator]
    )
  )
end

system.router.register(
  Router::RemoveBasename.new(
    extensions: config[:router_remove_basename_original_extensions],
    basenames: config[:router_remove_basename_route_basenames],
    keep_explicit: config[:router_remove_basename_keep_explicit]
  )
)

system.router.register(
  Router::AddDirectoryIndex.new(
    extensions: config[:router_add_index_original_extensions],
    index: config[:router_add_index_basename]
  )
)

system.router.register(
  Router::AutoAddExtension.new(
    keep_extensions: config[:router_keep_extensions]
  )
)
