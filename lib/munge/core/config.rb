module Munge
  module Core
    class Config
      def initialize(abspath)
        @datastore =
          read_yaml(abspath)
            .map { |key, value| [key.to_sym, value] }
            .to_h
      end

      def [](key)
        @datastore[key]
      end

      private

      def read_yaml(abspath)
        YAML.load_file(abspath) || {}
      end
    end
  end
end
