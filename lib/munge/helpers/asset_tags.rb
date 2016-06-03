module Munge
  module Helpers
    module AssetTags
      def stylesheet_link_tag(basename, options = {})
        options[:rel]  ||= "stylesheet"
        options[:href] ||= stylesheet_path(basename)

        empty_tag(:link, options)
      end

      def javascript_include_tag(basename, options = {})
        options[:type] ||= "text/javascript"
        options[:src]  ||= javascript_path(basename)

        content_tag(:script, options)
      end

      def inline_stylesheet_tag(basename, options = {})
        inline_asset_tag_helper(:style, stylesheets_root, basename, options)
      end

      def inline_javascript_tag(basename, options = {})
        inline_asset_tag_helper(:script, javascripts_root, basename, options)
      end

      private

      def inline_asset_tag_helper(tag, root, basename, options)
        rendered_asset = render(items["#{root}/#{basename}"])

        content_tag(tag, rendered_asset, options)
      end
    end
  end
end
