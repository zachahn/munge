module Munge
  module Util
    class Path
      def self.dirname(path)
        path_parts = path.split("/")
        path_parts[0..-2].join("/")
      end

      def self.extname(path)
        basename = File.basename(path)
        basename_parts = basename.split(".")

        if basename_parts.length > 1
          basename_parts[-1]
        else
          ""
        end
      end

      def self.basename_no_extension(path)
        basename = File.basename(path)
        basename_parts = basename.split(".")

        basename_parts[0] || ""
      end

      def self.path_no_extension(path)
        extension = extname(path)

        if extension == ""
          path
        else
          path.sub(/\.#{extension}/, "")
        end
      end

      def self.ensure_abspath(path)
        correct = path.squeeze("/")

        if correct[0] == "/"
          correct
        else
          "/#{correct}"
        end
      end

      def self.ensure_relpath(path)
        correct = path.squeeze("/")

        if correct[0] == "/"
          correct[1..-1]
        else
          correct
        end
      end
    end
  end
end
