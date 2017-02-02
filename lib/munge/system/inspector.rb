module Munge
  class System
    class Inspector
      def initialize
        @proc_block_registry = Hash.new([].freeze)
      end

      def handler(event, if: true, &block)
        condition = binding.local_variable_get(:if)
        @proc_block_registry[event] += [condition, block]
      end

      def breakpoint(event, caller_binding)
        h = @proc_block_registry[event]

        if h.empty?
          return
        end

        if should_run?(caller_binding, h.first)
          Pry.start(caller_binding)
        end
      end

      private

      def should_run?(caller_binding, condition)
        if [true, false].include?(condition)
          condition
        elsif condition.is_a?(String)
          caller_binding.eval(condition)
        else
          false
        end
      end
    end
  end
end
