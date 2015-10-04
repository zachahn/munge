module Munge
  class ItemFactory
    def initialize(source_path, binary_extensions, location, ignored_basenames)
      @source_path       = source_path
      @binary_extensions = Set.new(binary_extensions)
      @location          = location
      @ignored_basenames = ignored_basenames
    end

    def read(abspath)
      content, frontmatter = compute_content_and_frontmatter(abspath)

      relpath = compute_relpath(abspath)

      Munge::Item.new(
        type: compute_file_type(abspath),
        location: @location,
        abspath: abspath,
        relpath: relpath,
        id: compute_id(relpath),
        content: content,
        frontmatter: frontmatter,
        stat: compute_stat(abspath)
      )
    end

    # def imaginate(type, relpath, content, frontmatter)
    #   Munge::Item.new(
    #     type: type,
    #     location: :virtual,
    #     abspath: nil,
    #     relpath: relpath,
    #     id: compute_id(relpath),
    #     content: content,
    #     frontmatter: frontmatter,
    #     stat: nil
    #   )
    # end

    private

    def compute_content_and_frontmatter(abspath)
      case @location
      when :fs_memory
        content = Munge::Attribute::Content.new(File.read(abspath))
        [content.content, content.frontmatter]
      when :fs, :virtual
        ["", {}]
      else
        fail "invalid @location `#{@location}`"
      end
    end

    def file_extensions(filepath)
      extensions = File.basename(filepath).split(".")[1..-1]
      Set.new(extensions)
    end

    def compute_file_type(abspath)
      exts = file_extensions(abspath)

      if exts.intersect?(@binary_extensions)
        :binary
      else
        :text
      end
    end

    def compute_relpath(abspath)
      folder = Pathname.new(@source_path)
      file   = Pathname.new(abspath)

      file.relative_path_from(folder).to_s
    end

    def compute_stat(abspath)
      File.stat(abspath)
    end

    def compute_id(relpath)
      dirname  = compute_dirname(relpath)
      basename = compute_basename(relpath)

      id = []

      unless dirname == "."
        id.push(dirname)
      end

      unless @ignored_basenames.include?(basename)
        id.push(basename)
      end

      id.join("/")
    end

    def compute_dirname(relpath)
      dirname = File.dirname(relpath)
    end

    def compute_basename(relpath)
      filename = File.basename(relpath)
      filename.split(".").first
    end
  end
end
