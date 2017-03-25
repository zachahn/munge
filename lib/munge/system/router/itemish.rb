module Munge
  class System
    class Router
      class Itemish
        extend Forwardable

        def initialize(item, processor)
          @item = item
          @processor = processor
        end

        def compiled_content
          @compiled_content ||= @processor.transform(@item)
        end

        def_delegators :@item, :type, :relpath, :id, :frontmatter, :stat, :layout
        def_delegators :@item, :dirname, :filename, :basename, :extensions
        def_delegators :@item, :relpath?, :route?
      end
    end
  end
end
