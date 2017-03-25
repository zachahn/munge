module Munge
  # This class decides whether an item needs to be written.
  class WriteManager
    # @param driver [#exist?, #read]
    def initialize(driver:)
      @driver = driver
      @write_paths = []
    end

    # @param path [String] absolute path to file
    # @param content [String] new content of file
    # @return [Symbol] `:double_write_error`, `:identical`, `:different`
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
