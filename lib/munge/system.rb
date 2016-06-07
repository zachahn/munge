module Munge
  class System
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def initialize(root_path, config)
      source_path  = File.expand_path(config[:source], root_path)
      layouts_path = File.expand_path(config[:layouts], root_path)
      data_path    = File.expand_path(config[:data], root_path)

      @global_data = YAML.load_file(data_path) || {}

      @config = config

      source_item_factory =
        ItemFactory.new(
          text_extensions: config[:text_extensions] + config[:bintext_extensions],
          ignore_extensions: config[:dynamic_extensions]
        )

      layouts_item_factory =
        ItemFactory.new(
          text_extensions: config[:text_extensions] + config[:bintext_extensions],
          ignore_extensions: %w(.+)
        )

      @items =
        Collection.new(
          item_factory: source_item_factory,
          items: Readers::Filesystem.new(source_path)
        )

      @layouts =
        Collection.new(
          item_factory: layouts_item_factory,
          items: Readers::Filesystem.new(layouts_path)
        )

      @alterant =
        Processor.new

      @router =
        Router.new(
          alterant: @alterant
        )
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    attr_accessor :alterant
    attr_accessor :config
    attr_accessor :global_data
    attr_accessor :router
    attr_accessor :items
  end
end
