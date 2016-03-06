module Munge
  module Helpers
    module AssetPaths
      def image_path(basename)
        item = items["#{images_root}/#{basename}"]
        url_for(item)
      end

      def font_path(basename)
        item = items["#{fonts_root}/#{basename}"]
        url_for(item)
      end

      def stylesheet_path(basename)
        item = items["#{stylesheets_root}/#{basename}"]
        url_for(item)
      end

      def javascript_path(basename)
        item = items["#{javascripts_root}/#{basename}"]
        url_for(item)
      end
    end
  end
end