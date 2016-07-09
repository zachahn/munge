module Munge
  class System
    class Router
      class Itemish
        extend Forwardable

        def initialize(item, processor)
          @item      = item
          @processor = processor
        end

        def compiled_content
          @compiled_content ||= @processor.transform(@item)
        end

        def_delegators :@item, *%i(type relpath id frontmatter stat layout)
        def_delegators :@item, *%i(dirname filename basename extensions)
        def_delegators :@item, *%i(relpath? route?)
      end
    end
  end
end
