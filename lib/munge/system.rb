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

      source_item_factory =
        Core::ItemFactory.new(
          text_extensions: config[:text_extensions] + config[:bintext_extensions],
          ignore_extensions: false
        )

      layouts_item_factory =
        Core::ItemFactory.new(
          text_extensions: config[:text_extensions] + config[:bintext_extensions],
          ignore_extensions: true
        )

      @source =
        Core::Collection.new(
          item_factory: source_item_factory,
          items: Reader::Filesystem.new(source_path)
        )

      @layouts =
        Core::Collection.new(
          item_factory: layouts_item_factory,
          items: Reader::Filesystem.new(layouts_path)
        )

      @alterant =
        Core::Alterant.new

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
    attr_accessor :global_data
    attr_accessor :router
    attr_accessor :source
    attr_accessor :writer
  end
end
