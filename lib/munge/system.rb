module Munge
  class System
    def initialize(root_path, config)
      @root_path = root_path
      @config = config
    end

    def items
      return @items if @items

      source_path = File.expand_path(@config[:source_path], @root_path)

      source_item_factory =
        ItemFactory.new(
          text_extensions: @config[:items_text_extensions],
          ignore_extensions: @config[:items_ignore_extensions]
        )

      @items =
        Collection.new(
          item_factory: source_item_factory,
          items: Readers::Filesystem.new(source_path)
        )
    end

    def layouts
      return @layouts if @layouts

      layouts_path = File.expand_path(@config[:layouts_path], @root_path)

      layouts_item_factory =
        ItemFactory.new(
          text_extensions: @config[:layouts_text_extensions],
          ignore_extensions: %w(.+)
        )

      @layouts ||=
        Collection.new(
          item_factory: layouts_item_factory,
          items: Readers::Filesystem.new(layouts_path)
        )
    end

    def processor
      @processor ||= Processor.new
    end

    def router
      @router ||=
        Router.new(
          processor: processor
        )
    end

    def inspector
      @inspector =
        Inspector.new
    end

    def global_data
      return @global_data if @global_data

      data_path = File.expand_path(@config[:data_path], @root_path)
      @global_data = YAML.load_file(data_path) || {}
    end

    attr_reader :config
  end
end
