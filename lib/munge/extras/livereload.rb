if Gem.loaded_specs.key?("reel")
  require "celluloid/current"
  require "reel"

  require "munge/extras/livereload/update_server"
  require "munge/extras/livereload/update_client"
  require "munge/extras/livereload/messaging"
  require "munge/extras/livereload/server"
end

module Munge
  module Extras
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
