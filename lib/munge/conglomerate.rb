module Munge
  class Conglomerate
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
      if @layouts.nil?
        layouts_path = File.expand_path(@config[:layouts_path], @root_path)
        vfs = Vfs::Filesystem.new(layouts_path)

        @layouts =
          Collection.new(
            items: Reader.new(vfs, item_factory)
          )

        @layouts.each(&:transform)
      end

      @layouts
    end

    def processor
      @processor ||= Processor.new(self)
    end

    def router
      @router ||=
        Router.new(
          processor: processor
        )
    end

    def global_data
      if @global_data.nil?
        data_path = File.expand_path(@config[:data_path], @root_path)
        loaded_file = YAML.load_file(data_path) || {}
        @global_data = Munge::Util::SymbolHash.deep_convert(loaded_file)
      end

      @global_data
    end

    attr_reader :config
  end
end
