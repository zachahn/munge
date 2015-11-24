module Munge
  module Helper
    module Rendering
      def render(item, engines: nil, data: {}, content_override: nil)
        content   = content_override || item.content
        renderers = tilt_renderer_list(item, engines)
        mdata     = merged_data(item.frontmatter, data)

        render_string(content, data: mdata, engines: renderers)
      end

      def layout(item_or_string, data: {}, &block)
        layout_item = resolve_layout(item_or_string)
        renderers   = tilt_renderer_list(layout_item, nil)
        mdata       = merged_data(layout_item.frontmatter, data)

        render_string(layout_item.content, data: mdata, engines: renderers, &block)

        # if block_given?
        #   if block.binding.local_variable_defined?(:_erbout)
        #     layout_within_template(layout_item, mdata, &block)
        #   else
        #     layout_outside_template(layout_item, mdata, &block)
        #   end
        # else
        #   layout_without_block(layout_item, mdata)
        # end
      end

      def render_string(content, data: {}, engines: [])
        inner =
          if block_given?
            yield
          else
            nil
          end

        engines
          .inject(content) do |output, engine|
            template = engine.new { output }

            if inner
              template.render(self, data) { inner }
            else
              template.render(self, data)
            end
          end
      end

      def render_with_layout(item, content_engines: nil, data: {}, content_override: nil)
        inner = render(item, engines: content_engines, data: data, content_override: content_override)
        mdata = merged_data(item.frontmatter, data)

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
          data.inject(@global_data) do |merged, datum|
            merged.merge(datum)
          end

        hash_with_string_and_symbol_keys
          .each_with_object({}) do |(key, value), memo|
            memo[key.to_sym] = value
          end
      end

      def resolve_layout(item_or_string)
        if item_or_string.is_a?(String)
          @layouts[item_or_string]
        else
          item_or_string
        end
      end

      def layout_outside_template(layout_item, mdata, &block)
        engine_list = tilt_renderer_list(layout_item, nil)

        manual_render(layout_item.content, mdata, engine_list, &block)
      end

      def layout_within_template(layout_item, mdata, &block)
        original_erbout = block.binding.local_variable_get(:_erbout)

        block.binding.local_variable_set(:_erbout, "")

        result = layout_outside_template(layout_item, mdata) { block.call }

        final = original_erbout + result

        block.binding.local_variable_set(:_erbout, final)

        ""
      end

      def layout_without_block(layout_item, mdata)
        engine_list = tilt_renderer_list(layout_item, nil)

        manual_render(layout_item.content, mdata, engine_list)
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

      def manual_render(content, data, engine_list, &block)
        inner =
          if block_given?
            block.call
          else
            nil
          end

        engine_list
          .inject(content) do |output, engine|
            template = engine.new { output }

            if inner
              template.render(self, data) { inner }
            else
              template.render(self, data)
            end
          end
      end
    end
  end
end
