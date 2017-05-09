module Munge
  class System
    def initialize(root_path, config)
      @root_path = root_path
      @config = config
    end

    def item_factory
      @item_factory ||=
        ItemFactory.new(
          text_extensions: @config[:items_text_extensions],
          ignore_extensions: @config[:items_ignore_extensions]
        )
    end

    def items
      return @items if @items

      source_path = File.expand_path(@config[:source_path], @root_path)
      vfs = Vfs::Filesystem.new(source_path)

      @items =
        Collection.new(
          items: Reader.new(vfs, item_factory)
        )
    end

    def layouts
      return @layouts if @layouts

      layouts_path = File.expand_path(@config[:layouts_path], @root_path)
      vfs = Vfs::Filesystem.new(layouts_path)

      @layouts ||=
        Collection.new(
          items: Reader.new(vfs, item_factory)
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

    def global_data
      return @global_data if @global_data

      data_path = File.expand_path(@config[:data_path], @root_path)
      @global_data = YAML.load_file(data_path) || {}
    end

    attr_reader :config
  end
end
