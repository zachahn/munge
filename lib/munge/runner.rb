module Munge
  class Runner
    class << self
      def method_missing(method, root_path, *args)
        runner = new(application(root_path))
        runner.public_send(method, *args)
      end

      def respond_to_missing?(method, *)
        if instance_methods.include?(method)
          true
        else
          super
        end
      end

      def application(root_path)
        bootstrap = Munge::Bootstrap.new_from_dir(root_path: root_path)

        bootstrap.app
      end
    end

    def initialize(application)
      @app = application
    end

    def write
      @app.write do |item, did_write|
        if did_write
          puts "wrote #{item.route}"
        else
          puts "identical #{item.route}"
        end
      end
    end
  end
end
