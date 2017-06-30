module Munge
  module Helper
    module Rendering
      def render(item, engines: :use_extensions, data: {}, content_override: nil)
        mdata = merged_data(item.frontmatter, data, self_item: item)

        renderer =
          system.processor.private_renderer(
            filename: item.relpath,
            content: content_override || item.content,
            view_scope: current_view_scope,
            engines: [engines].flatten.compact
          )

        renderer.call
      end

      def layout(item_or_string, data: {}, &block)
        layout_item = resolve_layout(item_or_string)

        inner_as_block =
          if block_given?
            inner = capture(&block)
            -> { inner }
          else
            nil
          end

        renderer =
          system.processor.private_renderer(
            filename: "(layout) #{layout_item.relpath}",
            content: layout_item.content,
            view_scope: current_view_scope,
            engines: %i[use_extensions],
            block: inner_as_block
          )

        output = renderer.call

        if block_given?
          append_to_erbout(block.binding, output)
        end

        output
      end

      private

      def merged_data(*data)
        hash_with_string_and_symbol_keys =
          data.reduce(system.global_data) do |merged, datum|
            merged.merge(datum)
          end

        Munge::Util::SymbolHash.deep_convert(hash_with_string_and_symbol_keys)
      end

      def resolve_layout(item_or_string)
        if item_or_string.is_a?(String)
          system.layouts[item_or_string]
        else
          item_or_string
        end
      end
    end
  end
end
