module Munge
  class WriteManager
    def initialize(driver:)
      @driver      = driver
      @write_paths = []
    end

    def status(path, content)
      if @write_paths.include?(path)
        return :double_write_error
      end

      @write_paths.push(path)

      if @driver.exist?(path) && @driver.read(path) == content
        return :identical
      else
        return :different
      end
    end
  end
end