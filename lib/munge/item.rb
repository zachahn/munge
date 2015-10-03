module Munge
  class Item
    def initialize(type:,
                   location:,
                   abspath:,
                   relpath:,
                   id:,
                   content: nil,
                   frontmatter: {},
                   stat: nil)
      @type        = type
      @location    = location
      @abspath     = abspath
      @relpath     = relpath
      @id          = id
      @content     = content
      @frontmatter = frontmatter
      @stat        = stat

      @route      = nil
      @layout     = nil
      @transforms = []
    end

    attr_reader :type, :location
    attr_reader :abspath, :relpath, :id
    attr_reader :content, :frontmatter
    attr_reader :stat

    attr_accessor :layout, :transforms

    def dirname
      if File.dirname(@relpath) == "."
        ""
      else
        File.dirname(@relpath)
      end
    end

    def filename
      File.basename(@relpath)
    end

    def basename
      filename.split(".").first
    end

    def [](key)
      @frontmatter[key]
    end

    def []=(key, value)
      @frontmatter[key] = value
    end

    def route=(new_route)
      @route =
        new_route
          .sub(%r(^/+), "")
          .sub(%r(/+$), "")
    end

    def route
      if @route
        "/#{@route}"
      end
    end

    def relpath?(*subdir_patterns)
      regexp = generate_regex(subdir_patterns)
      regexp === @relpath
    end

    # do not query with slashes
    def route?(*subdir_patterns)
      regexp = generate_regex(subdir_patterns)
      regexp === @route
    end

    def transform(transformer = :Tilt, *args)
      @transforms.push([transformer, args])
    end

    private

    def generate_regex(pattern_list)
      joined_pattern = pattern_list.join("/")
      Regexp.new("^#{joined_pattern}")
    end
  end
end
