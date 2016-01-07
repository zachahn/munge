module Munge
  module Util
    class SymbolHash
      class << self
        def deep_convert(obj)
          if obj.is_a?(Hash)
            convert_hash(obj)
          elsif obj.is_a?(Array)
            obj.map do |i|
              deep_convert(i)
            end
          else
            obj
          end
        end

        private

        def convert_hash(obj)
          converted_hash = {}

          obj.each do |key, value|
            if key.is_a?(String) || key.is_a?(Symbol)
              converted_hash[key.to_sym] = deep_convert(value)
            else
              converted_hash[key] = value
            end
          end

          converted_hash
        end
      end
    end
  end
end
