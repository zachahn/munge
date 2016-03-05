tilt_transformer = Transformer::Tilt.new(system)
tilt_transformer.register(Munge::Helpers::Capture)
tilt_transformer.register(Munge::Helpers::Find)
tilt_transformer.register(Munge::Helpers::Link)
tilt_transformer.register(Munge::Helpers::Rendering)
tilt_transformer.register(Munge::Helpers::Tag)
tilt_transformer.register(Munge::Helpers::AssetPaths)
tilt_transformer.register(Munge::Helpers::AssetTags)
tilt_transformer.register(AssetRoots)

system.alterant.register(tilt_transformer)
