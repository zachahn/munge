require "munge/go/sass"

Munge::Go.add_sass_load_path!(root_path, config[:source_path], AssetRoots.stylesheets_root)

Munge::Go.set_sass_conglomerate!(conglomerate)

Munge::Go.add_sass_functions!(AssetRoots)
