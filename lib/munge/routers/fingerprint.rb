module Munge
  module Router
    class Fingerprint
      def initialize(extensions:,
                     separator: "--")
        @extensions = extensions
        @separator  = separator
      end

      def match?(initial_route, content, item)
        if item.frontmatter.has_key?(:fingerprint_asset)
          return item.frontmatter[:fingerprint_asset]
        end

        intersection = item.extensions & @extensions

        if intersection.size == 0
          false
        else
          true
        end
      end

      def route(initial_route, content, _item)
        generate_link(initial_route, content)
      end

      def filepath(initial_route, content, _item)
        generate_link(initial_route, content)
      end

      private

      def generate_link(initial_route, content)
        pre, extension = disassemble(initial_route)
        asset_hash     = hash(content)

        if extension == ""
          "#{pre}#{@separator}#{asset_hash}"
        else
          "#{pre}#{@separator}#{asset_hash}.#{extension}"
        end
      end

      def hash(content)
        Digest::MD5.hexdigest(content)
      end

      def disassemble(path)
        extension              = Util::Path.extname(path)
        path_without_extension = Util::Path.path_no_extension(path)

        [
          path_without_extension,
          extension
        ]
      end
    end
  end
end
