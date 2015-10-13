module Munge
  module Helper
    module Link
      def url_for(item)
        @router.route(item)
      end

      def link_to(item, text = nil, **opts)
        link = url_for(item)

        optstr = opts.map { |key, val| %(#{key}="#{val}") }

        parts =
          [
            [
              "<a",
              %(href="#{link}"),
              optstr
            ].flatten.join(" "),
            ">",
            text || link,
            "</a>"
          ]

        parts.join
      end
    end
  end
end
