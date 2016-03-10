module Munge
  class Runner
    def initialize(application:)
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
