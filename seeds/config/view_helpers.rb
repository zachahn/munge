tilt_transformer = Transformer::Tilt.new(system)
tilt_transformer.register(Munge::Helper::Capture)
tilt_transformer.register(Munge::Helper::Find)
tilt_transformer.register(Munge::Helper::Link)
tilt_transformer.register(Munge::Helper::Rendering)
tilt_transformer.register(Munge::Helper::Tag)

system.alterant.register(tilt_transformer)
