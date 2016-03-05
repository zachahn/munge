module Munge
  class System
    class Router
      class Itemish
        extend Forwardable

        def initialize(item, alterant)
          @item     = item
          @alterant = alterant
        end

        def compiled_content
          @compiled_content ||= @alterant.transform(@item)
        end

        def_delegators :@item, *%i(type relpath id frontmatter stat layout)
        def_delegators :@item, *%i(dirname filename basename extensions)
        def_delegators :@item, *%i(relpath? route?)
      end
    end
  end
end
