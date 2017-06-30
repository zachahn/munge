module Munge
  module Helper
    module Rendering
      def render(item, engines: nil, data: {}, content_override: nil)
        renderers = system.processor.engines_for(item, engines)
        mdata = merged_data(item.frontmatter, data, self_item: item)

        renderer =
          system.processor.fixer_upper.renderer(
            filename: item.relpath,
            content: content_override || item.content,
            view_scope: current_view_scope,
            engines: renderers
          )

        renderer.call
      end

      def layout(item_or_string, data: {}, &block)
        layout_item = resolve_layout(item_or_string)
        renderers = system.processor.engines_for(layout_item)
        mdata = merged_data(layout_item.frontmatter, data, self_layout: layout_item)
        layout_path = "(layout) #{layout_item.relpath}"

        render_string(layout_item.content, data: mdata, engines: renderers, template_name: layout_path, &block)
      end

      def render_string(content, data: {}, engines: [], template_name: nil, &block)
        inner =
          if block_given?
            capture(&block)
          end

        inner_as_block =
          if block_given?
            -> { inner }
          else
            nil
          end

        renderer =
          system.processor.fixer_upper.renderer(
            filename: template_name,
            content: content,
            view_scope: current_view_scope,
            engines: engines,
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
