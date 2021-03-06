module Munge
  module Helper
    module AssetTags
      def stylesheet_tag(basename, options = {})
        options[:rel] ||= "stylesheet"
        options[:href] ||= stylesheet_path(basename)

        empty_tag(:link, options)
      end

      def javascript_tag(basename, options = {})
        options[:type] ||= "text/javascript"
        options[:src] ||= javascript_path(basename)

        content_tag(:script, options)
      end

      def image_tag(basename, options = {})
        options[:src] ||= image_path(basename)

        empty_tag(:img, options)
      end

      def inline_stylesheet_tag(basename, options = {})
        inline_asset_tag_helper(stylesheets_root, basename, :style, options)
      end

      def inline_javascript_tag(basename, options = {})
        inline_asset_tag_helper(javascripts_root, basename, :script, options)
      end

      private

      def inline_asset_tag_helper(asset_root, basename, tag, options)
        path_to_asset = File.join(asset_root, basename)
        rendered_asset = render(items[path_to_asset])

        content_tag(tag, rendered_asset, options)
      end
    end
  end
end
