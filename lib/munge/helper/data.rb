module Munge
  module Helper
    module Data
      def data_stack
        @data_stack ||= []
      end

      def globals
        data_stack[0]
      end

      def instance
        data_stack[1]
      end

      def frontmatter
        data_stack.last
      end
    end
  end
end
