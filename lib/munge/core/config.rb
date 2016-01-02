module Munge
  module Core
    class Config
      class << self
        def read(path)
          abspath = File.expand_path(path)

          Munge::Util::SymbolHash.deep_convert(read_yaml(abspath))
        end

        private

        def read_yaml(abspath)
          YAML.load_file(abspath) || {}
        end
      end
    end
  end
end
