module Munge
  module Helper
    module AssetPaths
      def image_path(basename)
        item = items["#{images_root}/#{basename}"]
        path_to(item)
      end

      def font_path(basename)
        item = items["#{fonts_root}/#{basename}"]
        path_to(item)
      end

      def stylesheet_path(basename)
        item = items["#{stylesheets_root}/#{basename}"]
        path_to(item)
      end

      def javascript_path(basename)
        item = items["#{javascripts_root}/#{basename}"]
        path_to(item)
      end
    end
  end
end
