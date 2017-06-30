module Munge
  module Helper
    module DefineModule
      def self.new(name, value)
        Module.new do
          define_method(name) do
            value
          end
        end
      end
    end
  end
end
