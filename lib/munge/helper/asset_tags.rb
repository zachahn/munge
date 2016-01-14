module Munge
  module Helper
    module AssetTags
      def stylesheet_tag(basename, options = {})
        options[:rel]  = "stylesheet"
        options[:href] = stylesheet_url(basename)

        empty_tag(:link, options)
      end

      def javascript_tag(basename, options = {})
        options[:type] = "text/javascript"
        options[:src]  = javascript_url(basename)

        content_tag(:script, options)
      end

      def inline_stylesheet_tag(basename, options = {})
        rendered_stylesheet = render(items["#{stylesheets_root}/#{basename}"])

        content_tag(:style, rendered_stylesheet, options)
      end

      def inline_javascript_tag(basename, options = {})
        rendered_javascript = render(items["#{javascripts_root}/#{basename}"])

        content_tag(:script, rendered_javascript, options)
      end
    end
  end
end
