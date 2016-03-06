require "munge/go/sass"

setup_sass_path!(root_path, config[:source], AssetRoots.stylesheets_root)

setup_sass_system!(system)

setup_sass_with_module!(AssetRoots)
