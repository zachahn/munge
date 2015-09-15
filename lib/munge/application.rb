module Munge
  class Application
    def initialize(config_path)
      @config = YAML.load_file(File.expand_path(config_path))
      @root   = File.dirname(File.expand_path(config_path))

      @source_dir = File.expand_path(@config["source"], @root)
      @dest_dir   = File.expand_path(@config["dest"], @root)

      @source = Source.new(@source_dir)
    end

    attr_reader :source

    def write
      @source
        .reject { |item| item.route.nil? }
        .map    { |item| [item, resolve_write_path(item)] }
        .each   { |_, dest_path| FileUtils.mkdir_p(File.dirname(dest_path)) }
        .each   { |item, dest_path| File.write(dest_path, item.rendered_content) }
    end

    private

    def resolve_write_path(item)
      if item.route[-1] == "/"
        File.join(@dest_dir, item.route, @config["index"])
      else
        File.join(@dest_dir, item.route)
      end
    end
  end
end
