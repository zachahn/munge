require "munge/go/sass"

Munge::Go::add_sass_load_path!(root_path, config[:source], AssetRoots.stylesheets_root)

Munge::Go::set_sass_system!(system)

Munge::Go::add_sass_functions!(AssetRoots)
