module Munge
  class Item
    def initialize(type:,
                   relpath:,
                   id:,
                   content: nil,
                   frontmatter: {},
                   stat: nil)
      @type        = type
      @relpath     = relpath
      @id          = id
      @content     = content
      @frontmatter = frontmatter
      @stat        = stat

      @route      = nil
      @layout     = nil
      @transforms = []
    end

    attr_reader :type
    attr_reader :relpath, :id
    attr_reader :content, :frontmatter
    attr_reader :stat

    attr_reader :layout, :transforms

    def dirname
      Munge::Util::Path.dirname(@relpath)
    end

    def filename
      Munge::Util::Path.basename(@relpath)
    end

    def basename
      Munge::Util::Path.basename_no_extension(@relpath)
    end

    def extensions
      Munge::Util::Path.extnames(@relpath)
    end

    def [](key)
      @frontmatter[key]
    end

    def []=(key, value)
      @frontmatter[key] = value
    end

    def route=(new_route)
      @route = remove_surrounding_slashes(new_route)
    end

    def route
      if @route
        "/#{@route}"
      end
    end

    def relpath?(*subdir_patterns)
      regexp = generate_regex(subdir_patterns)
      Munge::Util::BooleanRegex.match?(regexp, @relpath)
    end

    # do not query with slashes
    def route?(*subdir_patterns)
      regexp = generate_regex(subdir_patterns)
      Munge::Util::BooleanRegex.match?(regexp, @route)
    end

    def layout=(new_layout)
      @layout = remove_surrounding_slashes(new_layout)
    end

    def transform(transformer = :tilt, *args)
      @transforms.push([transformer, args])
    end

    def freeze
      freeze_all_instance_variables

      super
    end

    private

    def generate_regex(pattern_list)
      joined_pattern = pattern_list.join("/")
      Regexp.new("^#{joined_pattern}")
    end

    def remove_surrounding_slashes(string)
      string
        .sub(%r{^/+}, "")
        .sub(%r{/+$}, "")
    end

    def freeze_all_instance_variables
      instance_variables.each do |ivar|
        instance_variable_get(ivar).freeze
      end
    end
  end
end
