module Munge
  module Util
    class Config
      class << self
        def read(path)
          abspath = File.expand_path(path)

          yaml = read_yaml(abspath)

          config =
            if yaml.is_a?(Hash)
              yaml
            else
              {}
            end

          Munge::Util::SymbolHash.deep_convert(config)
        end

        private

        def read_yaml(abspath)
          YAML.load_file(abspath)
        end
      end
    end
  end
end
