module Munge
  class Cleaner
    def initialize(path_to_clean:, paths_to_write:, io:)
      @path_to_clean = path_to_clean
      @paths_to_write = paths_to_write
      @io = io
    end

    def orphans
      existing_files - @paths_to_write
    end

    def delete
      orphans.each { |orphan| @io.rm(orphan) }

      Dir.glob(File.join(@path_to_clean, "**", "*")).reverse_each do |dir|
        if !File.directory?(dir)
          next
        end

        @io.rmdir(dir)
      end
    end

    private

    def existing_files
      Dir.glob(File.join(@path_to_clean, "**", "*")).select { |path| File.file?(path) }
    end
  end
end
