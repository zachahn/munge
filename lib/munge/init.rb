module Munge
  class Init
    def initialize(root_path:,
                   config:,
                   setup_path:,
                   rules_path:)
      @root_path  = root_path
      @setup_path = setup_path
      @rules_path = rules_path
      @binding    = binding

      system = Munge::System.new(root_path, config)

      import(setup_path)

      @app = Munge::Application.new(system)

      import(rules_path)

      @app.items.each(&:freeze)
      @app.items.freeze
    end

    def config_path
      File.join(root_path, "config")
    end

    def import(file_path)
      absolute_file_path = File.expand_path(file_path, root_path)
      contents           = File.read(absolute_file_path)
      @binding.eval(contents, absolute_file_path)
    end

    attr_reader :app
    attr_reader :root_path
  end
end
