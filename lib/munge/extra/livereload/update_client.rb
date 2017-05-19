module Munge
  module Extra
    module Livereload
      class UpdateClient
        include Celluloid
        include Celluloid::Notifications

        def initialize(webserver)
          @webserver = webserver
          subscribe("changed_files", :notify_reload)
        end

        def notify_reload(_topic, changed_files)
          @webserver.notify_reload(changed_files)
        end
      end
    end
  end
end
