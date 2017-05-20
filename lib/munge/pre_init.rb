module Munge
  class PreInit
    def initialize(config_path)
      if !File.exist?(config_path)
        raise Munge::Error::ConfigRbNotFound, config_path
      end

      @config_path = config_path
    end

    def config
      config = Munge::Config.new

      thread_variable_set_helper("config", config) do
        load @config_path
      end

      config
    end

    private

    def thread_variable_set_helper(key, value)
      Thread.current.thread_variable_set(key, value)

      yield

      Thread.current.thread_variable_set(key, nil)
    end
  end
end
