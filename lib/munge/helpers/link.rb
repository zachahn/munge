module Munge
  module Helpers
    module Link
      def path_to(item)
        system.router.route(item)
      end

      def link_to(item, text = nil, opts = {})
        link = path_to(item)

        if text.is_a?(Hash)
          opts = text
          text = nil
        end

        href_with_options = { href: link }.merge(opts)

        content_tag(:a, text || link, href_with_options)
      end
    end
  end
end
