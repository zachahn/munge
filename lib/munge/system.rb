module Munge
  class System
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def initialize(root_path, config)
      source_path  = File.expand_path(config[:source], root_path)
      layouts_path = File.expand_path(config[:layouts], root_path)
      output_path  = File.expand_path(config[:output], root_path)
      data_path    = File.expand_path(config[:data], root_path)

      @global_data = YAML.load_file(data_path) || {}

      @config = config

      @item_factory =
        Core::ItemFactory.new(
          text_extensions: config[:text_extensions],
          ignored_basenames: config[:ignored_basenames]
        )

      @source =
        Core::Collection.new(
          item_factory: @item_factory,
          items: Reader::Filesystem.new(source_path)
        )

      @layouts =
        Core::Collection.new(
          item_factory: @item_factory,
          items: Reader::Filesystem.new(layouts_path)
        )

      @alterant =
        Core::Alterant.new(scope: self)

      @router =
        Core::Router.new(
          alterant: @alterant
        )

      @writer =
        Core::Write.new(
          output: output_path
        )
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    attr_accessor :alterant
    attr_accessor :config
    attr_accessor :router
    attr_accessor :source
    attr_accessor :writer
  end
end
