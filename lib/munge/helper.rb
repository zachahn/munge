module Munge
  module Helper
    def self.load(object, container = self)
      container.constants
        .map  { |sym| container.const_get(sym) }
        .each { |helper| object.extend(helper) }

      object
    end
  end
end
