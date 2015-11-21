module Munge
  class ItemFactory
    def initialize(text_extensions:,
                   ignored_basenames:)
      @text_extensions = Set.new(text_extensions)
      @ignored_basenames = ignored_basenames
    end

    def build(relpath:,
              content:,
              frontmatter: {},
              stat: nil)
      type = compute_file_type(relpath)

      id =
        if type == :text
          compute_id(relpath)
        else
          relpath
        end

      Munge::Item.new(
        relpath: relpath,
        content: content,
        frontmatter: frontmatter,
        stat: stat,
        type: type,
        id: id
      )
    end

    def parse(relpath:,
              content:,
              stat: nil)
      type = compute_file_type(relpath)

      if type == :text
        parsed = Munge::Attribute::Content.new(content)

        build(
          relpath: relpath,
          content: parsed.content,
          frontmatter: parsed.frontmatter,
          stat: stat
        )
      else
        build(
          relpath: relpath,
          content: content,
          frontmatter: {},
          stat: stat
        )
      end
    end

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

      if exts.intersect?(@text_extensions)
        :text
      else
        :binary
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
