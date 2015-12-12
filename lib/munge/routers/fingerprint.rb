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

        "#{pre}#{@separator}#{asset_hash}.#{extension}"
      end

      def hash(content)
        Digest::MD5.hexdigest(content)
      end

      def disassemble(path)
        dirname         = File.dirname(path)
        basename        = File.basename(path)
        split_basename  = basename.split(".")
        basename_no_ext = split_basename[0..-2]
        extension       = split_basename[-1]

        [
          File.join(dirname, basename_no_ext),
          extension
        ]
      end
    end
  end
end
