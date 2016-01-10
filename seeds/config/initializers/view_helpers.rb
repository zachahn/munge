tilt_transformer = Transformer::Tilt.new(system)
tilt_transformer.register(Munge::Helper::Capture)
tilt_transformer.register(Munge::Helper::Find)
tilt_transformer.register(Munge::Helper::Link)
tilt_transformer.register(Munge::Helper::Rendering)

system.alterant.register(tilt_transformer)
