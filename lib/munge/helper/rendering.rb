module Munge
  module Helper
    module Rendering
      def render(item, manual_engine = nil, **additional_data, &content_block)
        content   = resolve_render_content(item, &content_block)
        renderers = resolve_render_renderer(item, manual_engine)
        data      = merged_data(item.frontmatter, additional_data)

        renderers
          .inject(content) do |output, engine|
            template = engine.new { output }
            template.render(self, data)
          end
      end

      def layout(item_or_string, **additional_data, &block)
        data =
          if item_or_string.is_a?(String)
            merged_data(additional_data)
          else
            merged_data(item_or_string.frontmatter, additional_data)
          end

        layout_item =
          if item_or_string.is_a?(String)
            find_layout(item_or_string)
          else
            item_or_string
          end

        actual_layout = layout_item

        if block_given?
          if block.binding.local_variable_defined?(:_erbout)
            layout_within_template(actual_layout, data, &block)
          else
            layout_outside_template(actual_layout, data, &block)
          end
        else
          layout_without_block(actual_layout, data)
        end
      end

      def render_with_layout(item, manual_engine = nil, **additional_data, &content_block)
        data = merged_data(item.frontmatter, additional_data)

        inner =
          if block_given?
            render(item, manual_engine, **data, &content_block)
          else
            render(item, manual_engine, **data)
          end

        if item.layout.nil?
          inner
        else
          layout(item.layout, data) do
            inner
          end
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

      def find_layout(path)
        @layouts[path]
      end

      def layout_within_template(actual_layout, additional_data, &block)
        original_erbout = block.binding.local_variable_get(:_erbout)

        block.binding.local_variable_set(:_erbout, "")

        inside = block.call

        template = ::Tilt.new { actual_layout.content }
        result = template.render(self, merged_data(additional_data)) do
          inside
        end

        final = original_erbout + result

        block.binding.local_variable_set(:_erbout, final)

        ""
      end

      def layout_outside_template(layout_item, additional_data, &block)
        engine_list = tilt_renderer_list(layout_item, nil)

        manual_render(layout_item.content, additional_data, engine_list, &block)
      end

      def layout_without_block(actual_layout, additional_data)
        template = ::Tilt.new(actual_layout)
        template.render(self, merged_data(additional_data))
      end

      def resolve_render_content(item, &content_block)
        if block_given?
          content_block.call
        else
          item.content
        end
      end

      def resolve_render_renderer(item, manual_engine)
        if manual_engine.nil?
          ::Tilt.templates_for(item.relpath)
        else
          [::Tilt[manual_engine]].compact
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

      def manual_render(content, data, engine_list)
        inner =
          if block_given?
            yield
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
