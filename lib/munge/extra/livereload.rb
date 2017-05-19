if Gem.loaded_specs.key?("reel")
  require "celluloid/current"
  require "reel"

  require "munge/extra/livereload/update_server"
  require "munge/extra/livereload/update_client"
  require "munge/extra/livereload/messaging"
  require "munge/extra/livereload/server"
end

module Munge
  module Extra
    module Livereload
      class Main
        def initialize(activated)
          @activated = activated

          if @activated
            Server.supervise
            @updater = UpdateServer.new
          end
        end

        def notify_changes(files:)
          if @activated
            @updater.notify(files)
          end
        end
      end
    end
  end
end
