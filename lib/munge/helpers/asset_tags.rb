module Munge
  module Helpers
    module AssetTags
      def stylesheet_tag(basename, options = {})
        options[:rel]  ||= "stylesheet"
        options[:href] ||= stylesheet_path(basename)

        empty_tag(:link, options)
      end

      def javascript_tag(basename, options = {})
        options[:type] ||= "text/javascript"
        options[:src]  ||= javascript_path(basename)

        content_tag(:script, options)
      end

      def inline_stylesheet_tag(basename, options = {})
        inline_asset_tag_helper(stylesheets_root, basename, :style, options)
      end

      def inline_javascript_tag(basename, options = {})
        inline_asset_tag_helper(javascripts_root, basename, :script, options)
      end

      private

      def inline_asset_tag_helper(root, basename, tag, options)
        rendered_asset = render(items["#{root}/#{basename}"])

        content_tag(tag, rendered_asset, options)
      end
    end
  end
end
