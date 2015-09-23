module Munge
  class Application
    # rubocop:disable Metrics/AbcSize
    def initialize(config_path)
      config = YAML.load_file(File.expand_path(config_path))

      root_dir    = File.dirname(File.expand_path(config_path))
      source_dir  = File.expand_path(config["source"], root_dir)
      layouts_dir = File.expand_path(config["layouts"], root_dir)
      output_dir  = File.expand_path(config["output"], root_dir)

      data = YAML.load_file(File.expand_path(config["data"], root_dir))

      @transform = Munge::Utility::Transform.new(source_dir, layouts_dir, data)
      @source    = Munge::Source.new(source_dir, config["binary_extensions"])
      @writer    = Munge::Utility::Write.new(output_dir, config["index"])
    end
    # rubocop:enable Metrics/AbcSize

    attr_reader :source

    def write
      @source
        .reject { |item| item.route.nil? }
        .each   { |item| render_and_write(item) }
    end

    private

    def render_and_write(item)
      @writer.write(item.route, @transform.call(item.content))
    end
  end
end
