module Munge
  module Helpers
    module Livereload
      def livereload_script(force: false)
        should_show = ENV["MUNGE_ENV"] == "development" && Gem.loaded_specs.key?("reel")

        loading_script =
          %q(document.write('<script src="http://') +
          %q( + (location.host || 'localhost').split(':')[0]) +
          %q( + ':35729/livereload.js?snipver=1"></') +
          %q( + 'script>'))

        if should_show || force
          content_tag(:script, loading_script)
        end
      end
    end
  end
end
