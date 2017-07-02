module Munge
  module Helper
    module Rendering
      def render(item, engines: :use_extensions, data: {}, content_override: nil)
        merged_data = item.frontmatter.merge(data)
        inner_view_scope = current_view_scope.clone
        inner_view_scope.instance_variable_set(:@data_stack, data_stack.dup)
        inner_view_scope.data_stack.push(merged_data)

        renderer =
          conglomerate.processor.private_renderer(
            filename: item.relpath,
            content: content_override || item.content,
            view_scope: inner_view_scope,
            engines: [engines].flatten.compact
          )

        renderer.call
      end

      def layout(item_or_string, data: {}, &block)
        layout_item =
          if item_or_string.is_a?(String)
            conglomerate.layouts[item_or_string]
          else
            item_or_string
          end

        inner_as_block =
          if block_given?
            inner = capture(&block)
            -> { inner }
          else
            nil
          end

        renderer =
          conglomerate.processor.private_renderer(
            filename: "(layout) #{layout_item.relpath}",
            content: layout_item.content,
            view_scope: current_view_scope.clone,
            engines: %i[use_extensions],
            block: inner_as_block
          )

        output = renderer.call

        if block_given?
          append_to_erbout(block.binding, output)
        end

        output
      end
    end
  end
end
