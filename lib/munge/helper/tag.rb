module Munge
  module Helper
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

        html_attributes =
          if options.any?
            " " + options.map { |k, v| %(#{k}="#{h(v)}") }.join(" ")
          end

        inner_html =
          if content
            content
          elsif block_given?
            capture(&block)
          end

        "<#{name}#{html_attributes}>#{inner_html}</#{name}>"
      end

      def h(string)
        CGI.escape_html(string.to_s)
      end
    end
  end
end
