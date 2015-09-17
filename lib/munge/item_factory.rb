module Munge
  class ItemFactory
    def initialize(binary_extensions, sourcepath)
      @binary_extensions = binary_extensions
      @sourcepath        = sourcepath
    end

    def create(filepath)
      path    = Munge::Attribute::Path.new(@sourcepath, filepath)
      content = Munge::Attribute::Content.new(path.absolute)
      stat    = Munge::Attribute::Metadata.new(filepath)

      if binary_extension?(filepath)
        Munge::Item::Binary.new(path, content, stat)
      else
        Munge::Item::Text.new(path, content, stat)
      end
    end

    private

    def binary_extension?(filepath)
      file_extensions = File.basename(filepath).split(".")[1..-1]

      extensions_intersection = @binary_extensions & file_extensions

      !extensions_intersection.empty?
    end
  end
end
