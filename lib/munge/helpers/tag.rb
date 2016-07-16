module Munge
  module Helpers
    module Tag
      def empty_tag(name, options = {})
        options_str = options.map { |k, v| %(#{k}="#{h(v)}") }.join(" ")

        if options_str == ""
          "<#{name} />"
        else
          "<#{name} #{options_str} />"
        end
      end

      def content_tag(name, content = nil, options = {}, &block)
        if content.is_a?(Hash)
          options = content
          content = nil
        end

        options_str = options.map { |k, v| %(#{k}="#{h(v)}") }.join(" ")

        content_str =
          if content
            content
          elsif block_given?
            capture(&block)
          else
            ""
          end

        "<#{name} #{options_str}>#{content_str}</#{name}>"
      end

      def h(string)
        CGI.escape_html(string.to_s)
      end
    end
  end
end
