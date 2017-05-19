module Munge
  module Helper
    module Capture
      def capture(&block)
        if block.binding.local_variable_defined?(:_erbout)
          original_erbout = block.binding.local_variable_get(:_erbout)
          block.binding.local_variable_set(:_erbout, "")

          captured_text = yield

          block.binding.local_variable_set(:_erbout, original_erbout)

          captured_text
        else
          yield
        end
      end

      def append_to_erbout(block_binding, text)
        if block_binding.local_variable_defined?(:_erbout)
          original_erbout = block_binding.local_variable_get(:_erbout)

          updated_erbout = original_erbout + text

          block_binding.local_variable_set(:_erbout, updated_erbout)
        end

        text
      end
    end
  end
end
