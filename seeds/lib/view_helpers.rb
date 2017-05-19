tilt_transformer = Transformers::TiltTransformer.new(system)
tilt_transformer.register(Munge::Helper::Capture)
tilt_transformer.register(Munge::Helper::Find)
tilt_transformer.register(Munge::Helper::Link)
tilt_transformer.register(Munge::Helper::Rendering)
tilt_transformer.register(Munge::Helper::Tag)
tilt_transformer.register(Munge::Helper::AssetPaths)
tilt_transformer.register(Munge::Helper::AssetTags)
tilt_transformer.register(Munge::Helper::Livereload)
tilt_transformer.register(AssetRoots)

system.processor.register(tilt_transformer)
