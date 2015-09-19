module Munge
  class Application
    def initialize(config_path)
      @config = YAML.load_file(File.expand_path(config_path))
      @root   = File.dirname(File.expand_path(config_path))

      @source_dir = File.expand_path(@config["source"], @root)
      @output_dir = File.expand_path(@config["output"], @root)

      @source = Source.new(@source_dir, @config["binary_extensions"])

      @writer = Munge::Utility::Write.new(@output_dir, @config["index"])
    end

    attr_reader :source

    def write
      @source
        .reject { |item| item.route.nil? }
        .each   { |item| @writer.write(item.route, item.content) }
    end
  end
end
