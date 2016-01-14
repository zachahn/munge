module Munge
  module Helper
    module AssetUrls
      def image_url(basename)
        item = items["#{images_root}/#{basename}"]
        url_for(item)
      end

      def font_url(basename)
        item = items["#{fonts_root}/#{basename}"]
        url_for(item)
      end

      def stylesheet_url(basename)
        item = items["#{stylesheets_root}/#{basename}"]
        url_for(item)
      end

      def javascript_url(basename)
        item = items["#{javascripts_root}/#{basename}"]
        url_for(item)
      end
    end
  end
end
