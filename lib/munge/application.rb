module Munge
  class Application
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def initialize(config_path)
      config = Core::Config.new(config_path)

      root_path    = File.dirname(File.expand_path(config_path))
      source_path  = File.expand_path(config[:source], root_path)
      layouts_path = File.expand_path(config[:layouts], root_path)
      output_path  = File.expand_path(config[:output], root_path)
      data_path    = File.expand_path(config[:data], root_path)

      @global_data = YAML.load_file(data_path) || {}

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

      @router =
        Core::Router.new(
          index:           config[:index],
          keep_extensions: config[:keep_extensions]
        )

      @alterant =
        Core::Alterant.new(scope: self)

      @writer =
        Core::Write.new(
          output: output_path
        )

      @alterant.register(Transformer::Tilt.new(self))
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    attr_reader :source

    def write(&block)
      @source
        .reject { |item| item.route.nil? }
        .each   { |item| render_and_write(item, &block) }
    end

    def build_virtual_item(*args)
      @source.build(*args)
    end

    def create(*args, &block)
      item = build_virtual_item(*args)
      yield item if block_given?
      @source.push(item)
    end

    private

    def render_and_write(item, &block)
      relpath = @router.filepath(item)

      write_status = @writer.write(relpath, @alterant.transform(item))

      if block_given?
        block.call(item, write_status)
      end
    end
  end
end
