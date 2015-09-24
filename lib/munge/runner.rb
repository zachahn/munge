module Munge
  class Runner
    class << self
      def method_missing(method, config_path, rules_path, *args)
        runner = new(config_path, rules_path)
        runner.public_send(method, *args)
      end

      def respond_to_missing?(method, *)
        if instance_methods.include?(method)
          true
        else
          super
        end
      end
    end

    def initialize(config_path, rules_path)
      @app = app = Munge::Application.new(config_path)

      binding.eval(File.read(rules_path), rules_path)
    end

    def write
      @app.write
    end
  end
end
