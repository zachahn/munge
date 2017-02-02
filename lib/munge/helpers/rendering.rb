module Munge
  module Helpers
    module Rendering
      def render(item, engines: nil, data: {}, content_override: nil)
        content   = content_override || item.content
        renderers = tilt_renderer_list(item, engines)
        mdata     = merged_data(item.frontmatter, data, self_item: item)
        item_path = item.relpath

        system.inspector.breakpoint(:render_item, binding)

        render_string(content, data: mdata, engines: renderers, template_name: item_path)
      end

      def layout(item_or_string, data: {}, &block)
        layout_item = resolve_layout(item_or_string)
        renderers   = tilt_renderer_list(layout_item, nil)
        mdata       = merged_data(layout_item.frontmatter, data, self_layout: layout_item)
        layout_path = "(layout) #{layout_item.relpath}"

        render_string(layout_item.content, data: mdata, engines: renderers, template_name: layout_path, &block)
      end

      def render_string(content, data: {}, engines: [], template_name: nil, &block)
        inner =
          if block_given?
            capture(&block)
          end

        output =
          engines
            .reduce(content) do |memoized_content, engine|
              options  = tilt_options[engine]
              template = engine.new(template_name, options) { memoized_content }

              template.render(self, data) { inner }
            end

        if block_given?
          append_to_erbout(block.binding, output)
        end

        output
      end

      def render_with_layout(item, content_engines: nil, data: {}, content_override: nil)
        inner = render(item, engines: content_engines, data: data, content_override: content_override)
        mdata = merged_data(item.frontmatter, data, self_item: item)

        if item.layout
          layout(item.layout, data: mdata) do
            inner
          end
        else
          inner
        end
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

      def tilt_renderer_list(item, preferred_engine)
        if preferred_engine
          tilt_renderers_from_preferred(preferred_engine)
        else
          tilt_renderers_from_path(item.relpath)
        end
      end

      def tilt_renderers_from_path(path)
        ::Tilt.templates_for(path)
      end

      def tilt_renderers_from_preferred(preferred_engines)
        preferred =
          if preferred_engines.is_a?(Array)
            preferred_engines.flatten.join(".")
          else
            preferred_engines
          end

        ::Tilt.templates_for(preferred)
      end
    end
  end
end
