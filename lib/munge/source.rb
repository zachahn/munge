module Munge
  class Source
    def initialize(source_abspath)
      @pattern = File.join(source_abspath, "**", "*")
    end

    def each
      return enum_for(:each) unless block_given?

      Dir.glob(@pattern) do |file|
        yield file
      end
    end
  end
end
