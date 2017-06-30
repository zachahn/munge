module Munge
  # Items are the core data object for building and manipulating pages.
  class Item
    def initialize(type:,
                   relpath:,
                   id:,
                   content: nil,
                   frontmatter: {},
                   stat: nil)
      @type = type
      @relpath = relpath
      @id = id
      @content = content
      @frontmatter = Munge::Util::SymbolHash.deep_convert(frontmatter)
      @stat = stat

      @route = nil
      @layout = nil
      @transforms = []
    end

    attr_reader :relpath, :id
    attr_reader :content, :frontmatter
    attr_reader :stat

    attr_reader :layout, :transforms

    # @return [String] dirname without leading "."
    def dirname
      Munge::Util::Path.dirname(@relpath)
    end

    # @return [String] filename
    def filename
      Munge::Util::Path.basename(@relpath)
    end

    # @return [String] filename before the first "."
    def basename
      Munge::Util::Path.basename_no_extension(@relpath)
    end

    # @return [String] relpath, without extensions
    def basepath
      dirname = Munge::Util::Path.dirname(@relpath)
      basename = Munge::Util::Path.basename_no_extension(@relpath)

      Munge::Util::Path.join(dirname, basename)
    end

    # @return [Array<String>] extensions (everything following the first ".")
    def extensions
      Munge::Util::Path.extnames(@relpath)
    end

    # @param key [String]
    def [](key)
      @frontmatter[key]
    end

    # @param key [String]
    def []=(key, value)
      @frontmatter[key] = value
    end

    # @param new_route [String] the compiled route to this item
    # @return [String] sanitized version of input
    def route=(new_route)
      @route = remove_surrounding_slashes(new_route)
    end

    # @return [String, nil] absolute route to this item, if set
    def route
      if @route
        "/#{@route}"
      end
    end

    # @return [true, false] whether or not this item is a text type
    #   (determined by extension)
    def text?
      @type == :text
    end

    # @return [true, false] whether or not this item is a binary type
    #   (determined by extension)
    def binary?
      @type == :binary
    end

    # Runs a regex match to see if item was found in the specified directory.
    # Do not query with any slashes. Each argument will automatically be joined
    # by slashes. Note though that the string will be converted into a regex.
    #
    # @param *subdir_patterns [Array<String>]
    # @return [true, false] whether or not this item was found in specified
    #   subdirectory
    def relpath?(*subdir_patterns)
      regexp = generate_regex(subdir_patterns)
      Munge::Util::BooleanRegex.match?(regexp, @relpath)
    end

    # Runs a regex match to see if the item matches a route. See #relpath?
    #
    # @param *subdir_patterns [Array<String>]
    # @return [true, false] whether or not this route belongs to specified
    #   subdirectory
    def route?(*subdir_patterns)
      regexp = generate_regex(subdir_patterns)
      Munge::Util::BooleanRegex.match?(regexp, @route)
    end

    # @param new_layout [String] layout to apply onto this item
    # @return [String] sanitized version of the input
    def layout=(new_layout)
      @layout = remove_surrounding_slashes(new_layout)
    end

    # @param transformer [Symbol] name of transformer to apply onto item when
    #   building
    # @return [void]
    def transform(transformer = :use_extensions)
      @transforms.push(transformer)
    end

    # Deep freeze. Freezes all instance variables as well as itself.
    #
    # @return [void]
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
