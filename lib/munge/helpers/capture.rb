module Munge
  module Helpers
    module Capture
      def capture(&block)
        if block.binding.local_variable_defined?(:_erbout)
          original_erbout = block.binding.local_variable_get(:_erbout)
          block.binding.local_variable_set(:_erbout, "")

          captured_text = block.call

          block.binding.local_variable_set(:_erbout, original_erbout)

          captured_text
        else
          block.call
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

      def yield_content(content_name, &block)
        @content_fors ||= Hash.new([].freeze)

        if @content_fors[content_name].empty?
          if block_given?
            inner = capture(&block)

            append_to_erbout(block.binding, inner)
          end
        else
          if block_given?
            @content_fors[content_name].each do |content|
              append_to_erbout(block.binding, content)
            end
          else
            @content_fors[content_name].join("\n")
          end
        end
      end

      def content_for(content_name, &block)
        @content_fors ||= Hash.new([].freeze)

        if block_given?
          inner = capture(&block)

          @content_fors[content_name] += [inner]
        end
      end
    end
  end
end
