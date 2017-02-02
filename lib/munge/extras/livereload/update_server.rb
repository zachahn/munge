module Munge
  module Extras
    module Livereload
      class UpdateServer
        include Celluloid
        include Celluloid::Notifications

        def notify(files = [])
          publish("changed_files", files)
        end
      end
    end
  end
end
