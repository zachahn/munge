module Munge
  module Helper
    module Link
      def path_to(itemish)
        item =
          if itemish.is_a?(String)
            system.items[itemish]
          else
            itemish
          end

        system.router.route(item)
      end

      def link_to(itemish, text = nil, opts = {})
        link = path_to(itemish)

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
