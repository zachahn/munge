module Munge
  module Router
    class RemoveIndexBasename
      def initialize(html_extensions:, index:)
        @html_extensions = html_extensions
        @index           = index
        @index_basename  = Munge::Util::Path.basename_no_extension(@index)
      end

      def match?(initial_route, _content, item)
        item_is_html?(item) && basename_is_index?(initial_route)
      end

      def route(initial_route, _content, _item)
        Munge::Util::Path.dirname(initial_route)
      end

      def filepath(initial_route, _content, _item)
        Munge::Util::Path.dirname(initial_route)
      end

      private

      def item_is_html?(item)
        intersection = item.extensions & @html_extensions

        intersection.length > 0
      end

      def basename_is_index?(route)
        File.basename(route) == @index_basename
      end
    end
  end
end
