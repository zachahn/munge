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

      global_data = YAML.load_file(data_path) || {}

      @source = Core::Source.new(
        source_path,
        config[:binary_extensions],
        :fs_memory,
        config[:ignored_basenames]
      )
      @transform = Core::Transform.new(
        source_path,
        layouts_path,
        global_data,
        @source
      )
      @router    = Core::Router.new(
        index: config[:index],
        keep_extensions: config[:keep_extensions]
      )
      @writer    = Core::Write.new(output_path, config[:index])
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    attr_reader :source

    def write(&block)
      @source
        .reject { |item| item.route.nil? }
        .each   { |item| render_and_write(item, &block) }
    end

    def build_virtual_item(*args)
      @source.build_virtual_item(*args)
    end

    def create(*args, &block)
      item = build_virtual_item(*args)
      yield item if block_given?
      @source.push(item)
    end

    private

    def render_and_write(item, &block)
      relpath = @router.filepath(item)

      write_status = @writer.write(relpath, @transform.call(item))

      if block_given?
        block.call(item, write_status)
      end
    end
  end
end
