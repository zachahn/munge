module Munge
  class Application
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def initialize(config_path)
      config = YAML.load_file(File.expand_path(config_path))

      root_path    = File.dirname(File.expand_path(config_path))
      source_path  = File.expand_path(config["source"], root_path)
      layouts_path = File.expand_path(config["layouts"], root_path)
      output_path  = File.expand_path(config["output"], root_path)
      data_path    = File.expand_path(config["data"], root_path)

      global_data = YAML.load_file(data_path) || {}

      @source = Core::Source.new(source_path, config["binary_extensions"])
      @scope_factory = Core::TransformScopeFactory.new(
        source_path,
        layouts_path,
        global_data,
        @source,
        Munge::Helper
      )
      @transform = Core::Transform.new(@scope_factory)
      @writer    = Core::Write.new(output_path, config["index"])
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    attr_reader :source

    def write
      @source
        .reject { |item| item.route.nil? }
        .each   { |item| render_and_write(item) }
    end

    private

    def render_and_write(item)
      @writer.write(item.route, @transform.call(item))
    end
  end
end
