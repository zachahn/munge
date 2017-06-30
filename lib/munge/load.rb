module Munge
  class Load
    def initialize(root_path)
      boot_config_path = File.join(root_path, "boot.yml")

      @root_path = Pathname.new(root_path)
      @boot_config = YAML.load(File.read(boot_config_path))
      @config = Munge::Config.new
    end

    def app
      Dir.chdir(@root_path) do
        config_load

        system = Munge::Conglomerate.new(@root_path.to_s, @config)
        application = Munge::Application.new(system)

        thread_variable_set_helper(@boot_config["system_key"], system) do
          thread_variable_set_helper(@boot_config["application_key"], application) do
            thread_variable_set_helper(@boot_config["config_key"], @config) do
              thread_variable_set_helper(@boot_config["root_path_key"], @root_path) do
                load_from_boot_config_key("boot_path")
                load_from_boot_config_key("rules_path")

                yield application, system
              end
            end
          end
        end
      end
    end

    private

    def thread_variable_set_helper(key, value)
      Thread.current.thread_variable_set(key, value)

      result = yield

      Thread.current.thread_variable_set(key, nil)

      result
    end

    def load_from_boot_config_key(key)
      abspath = @root_path.join(@boot_config[key])

      load abspath
    end

    def config_load
      return if @loaded_config
      @loaded_config = true

      thread_variable_set_helper(@boot_config["config_key"], @config) do
        load_from_boot_config_key("config_path")
      end
    end
  end
end
