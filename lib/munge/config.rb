module Munge
  class Config
    def initialize(**configs)
      @configs = configs
    end

    def [](key)
      sym_key = key.to_sym

      if @configs.key?(sym_key)
        @configs[sym_key]
      else
        raise Munge::Errors::ConfigKeyNotFound, sym_key
      end
    end

    def []=(key, value)
      @configs[key.to_sym] = value
    end

    def key?(key)
      @configs.key?(key)
    end

    def method_missing(method_name, *arguments)
      if setter_fn?(method_name)
        self[key_from_setter(method_name)] = arguments.first
      elsif key?(method_name)
        self[method_name]
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      if setter_fn?(method_name)
        true
      elsif key?(method_name)
        true
      else
        super
      end
    end

    private

    def setter_fn?(method_name)
      method_name.to_s.end_with?("=")
    end

    def key_from_setter(method_name)
      method_name.to_s.sub(/=$/, "").to_sym
    end
  end
end
