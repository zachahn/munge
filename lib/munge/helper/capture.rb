module Munge
  module Helper
    module Capture
      def capture(&block)
        original_erbout = block.binding.local_variable_get(:_erbout)
        block.binding.local_variable_set(:_erbout, "")

        captured_text = block.call

        block.binding.local_variable_set(:_erbout, original_erbout)

        captured_text
      end

      def append_to_erbout(block_binding, text)
        original_erbout = block_binding.local_variable_get(:_erbout)

        updated_erbout = original_erbout + text

        block_binding.local_variable_set(:_erbout, updated_erbout)
      end
    end
  end
end
