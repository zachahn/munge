module Munge
  class Item
    def self.create(source_abspath, file_abspath)
      path     = Munge::Attribute::Path.new(source_abspath, file_abspath)
      content  = Munge::Attribute::Content.new(File.read(file_abspath))
      metadata = Munge::Attribute::Metadata.new(file_abspath)

      new(path, content, metadata)
    end

    def initialize(path, content, metadata)
      @path     = path
      @content  = content
      @metadata = metadata
      @route    = nil
      @layout   = nil
    end

    attr_reader :path, :metadata
    attr_accessor :route, :layout

    def content
      @content.content
    end

    def content=(new_content)
      @content.content = new_content
    end

    def info
      @content.frontmatter
    end

    def render
      Tilt.templates_for(@path.relative).each do |engine|
        renderer = engine.new { self.content }
        self.content = renderer.render(nil, self.info)
      end
    end
  end
end
