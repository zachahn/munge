require "adsf"
require "rack"

module Munge
  class Commands
    class View
      def initialize(options, config_path)
        config    = Munge::Core::Config.new(config_path)
        rack_opts = { Host: options[:host], Port: options[:port] }

        app =
          Rack::Builder.new do
            use Rack::ShowExceptions
            use Rack::Head
            use Adsf::Rack::IndexFileFinder, root: config[:output]
            run Rack::File.new(config[:output])
          end

        Rack::Handler::WEBrick.run(app, rack_opts)
      end
    end
  end
end
