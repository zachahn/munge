module Munge
  module Item
    class Base
      def initialize(path = nil, content = nil, info = nil)
        @path       = path
        @content    = content
        @info       = info
        @layout     = nil
        @route      = nil
        @transforms = []
      end

      attr_reader :transforms
      attr_accessor :route, :layout

      def id
        if dirname == ""
          basename
        else
          "#{dirname}/#{basename}"
        end
      end

      def relpath
        @path.relative
      end

      def dirname
        if File.dirname(relpath) == "."
          ""
        else
          File.dirname(relpath)
        end
      end

      def filename
        File.basename(relpath)
      end

      def basename
        filename.split(".").first
      end

      def content
        @content.content
      end

      def frontmatter
        @content.frontmatter
      end

      def stat
        @info.stat
      end

      def virtual?
        false
      end

      def binary?
        false
      end

      def text?
        false
      end

      def transform(transformer = :tilt, *args)
        @transforms.push([transformer, args])
      end

      def [](key)
        frontmatter[key]
      end

      def []=(key, value)
        frontmatter[key] = value
      end
    end
  end
end
