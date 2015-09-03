require "pathname"

module Munge
  class Item
    class Path
      def initialize(source_path, file_path)
        @relative = resolve_relative(source_path, file_path).freeze
        @absolute = file_path.dup.freeze
        @basename = resolve_basename(file_path).freeze
        @extnames = resolve_extnames(file_path).freeze
      end

      attr_reader :relative, :absolute, :basename, :extnames

      private

      def resolve_relative(source_path, file_path)
        folder = Pathname.new(source_path)
        file   = Pathname.new(file_path)

        file.relative_path_from(folder).to_s
      end

      def resolve_basename(file_path)
        file_name = File.basename(file_path)
        file_name_parts = file_name.split(".")

        file_name_parts.first
      end

      def resolve_extnames(file_path)
        file_name = File.basename(file_path)
        file_name_parts = file_name.split(".")

        file_name_parts[1..-1]
      end
    end
  end
end
