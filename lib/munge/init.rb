module Munge
  # This class loads the user rules, as well as provides some useful methods
  # for setup.
  class Init
    include Munge::Util::Import

    # Initializing loads up the user's `setup.rb` and `rules.rb`.
    def initialize(root_path:,
                   config:,
                   setup_path:,
                   rules_path:)
      @root_path = root_path
      @setup_path = setup_path
      @rules_path = rules_path
      @binding = binding

      system = Munge::System.new(root_path, config)

      import(setup_path)

      @app = Munge::Application.new(system)

      import(rules_path)

      @app.items.each(&:freeze)
      @app.items.freeze
    end

    # @return [String] path to user's `lib/` directory
    def lib_path
      File.join(root_path, "lib")
    end

    # Loads file into current scope. Similar to `load "filename.rb"`
    #
    # @return [void]
    def import(file_path)
      absolute_file_path = File.expand_path(file_path, root_path)
      import_to_context(absolute_file_path, @binding)
    end

    attr_reader :app
    attr_reader :root_path
  end
end
