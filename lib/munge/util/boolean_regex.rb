module Munge
  module Util
    class BooleanRegex
      def self.match?(pattern, string)
        if pattern =~ string
          true
        else
          false
        end
      end
    end
  end
end
