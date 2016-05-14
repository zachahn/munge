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

      if !@driver.exist?(path)
        return :new
      end

      if @driver.read(path) == content
        return :identical
      end

      :changed
    end
  end
end
