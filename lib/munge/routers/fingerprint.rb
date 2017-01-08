module Munge
  module Routers
    class Fingerprint
      def initialize(extensions:,
                     separator:)
        @extensions = extensions
        @separator  = separator
      end

      def type
        :route
      end

      def match?(_initial_route, item)
        if item.frontmatter.key?(:fingerprint_asset)
          return item.frontmatter[:fingerprint_asset]
        end

        intersection = item.extensions & @extensions

        !intersection.empty?
      end

      def call(initial_route, item)
        generate_link(initial_route, item.compiled_content)
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
        Digest::SHA256.hexdigest(content)
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
