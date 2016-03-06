module Munge
  module Helpers
    module Link
      def url_for(item)
        @router.route(item)
      end

      def link_to(item, text = nil, opts = {})
        link = url_for(item)

        if text.is_a?(Hash)
          opts = text
          text = nil
        end

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