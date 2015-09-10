module Munge
  class Item
    def self.create(source_abspath, file_abspath)
      path     = Munge::Attribute::Path.new(source_abspath, file_abspath)
      metadata = Munge::Attribute::Metadata.new(file_abspath)

      new(path, metadata)
    end

    def initialize(path, metadata)
      @path     = path
      @metadata = metadata
      @route    = nil
      @layout   = nil
    end

    attr_reader :path, :metadata
    attr_accessor :route, :layout
  end
end
