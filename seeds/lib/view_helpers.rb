system.processor.include(AssetRoots)

system.processor.register("erb", to: Tilt::ERBTemplate)
system.processor.register("scss", to: Tilt::ScssTemplate)
