module Munge
  module Util
    class Path
      def self.dirname(path)
        if File.dirname(path) == "."
          ""
        else
          File.dirname(path)
        end
      end

      def self.extname(path)
        filename = basename(path)
        filename_parts = filename.split(".")

        if filename_parts.length > 1
          filename_parts[-1]
        else
          ""
        end
      end

      def self.extnames(path)
        filename = basename(path)
        filename_parts = filename.split(".")

        filename_parts[1..-1]
      end

      def self.basename(path)
        File.basename(path)
      end

      def self.basename_no_extension(path)
        filename = basename(path)
        filename_parts = filename.split(".")

        filename_parts[0] || ""
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

      def self.join(*path_components)
        path_components
          .reject(&:empty?)
          .join("/")
      end
    end
  end
end
