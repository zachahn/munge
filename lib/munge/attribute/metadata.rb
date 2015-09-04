module Munge
  module Attribute
    class Metadata
      def initialize(abspath)
        @abspath = abspath
        @stat    = File::Stat.new(abspath)
      end

      attr_reader :stat
    end
  end
end
