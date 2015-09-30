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

      def layout(path, **additional_data, &block)
        actual_layout = find_layout(path)

        if block_given?
          if block.binding.local_variable_defined?(:_erbout)
            layout_within_template(actual_layout, additional_data, &block)
          else
            layout_outside_template(actual_layout, additional_data, &block)
          end
        else
          layout_without_block(actual_layout, additional_data)
        end
      end

      def render_with_layout(item, manual_engine = nil, **additional_data, &content_block)
        data =
          merged_data(item.frontmatter, additional_data)

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
        pattern = File.join(@layouts_path, path)
        Dir["#{pattern}*"].first
      end

      def layout_within_template(actual_layout, additional_data, &block)
        original_erbout = block.binding.local_variable_get(:_erbout)

        block.binding.local_variable_set(:_erbout, "")

        inside = block.call

        template = ::Tilt.new(actual_layout)
        result = template.render(self, merged_data(additional_data)) do
          inside
        end

        final = original_erbout + result

        block.binding.local_variable_set(:_erbout, final)

        ""
      end

      def layout_outside_template(actual_layout, additional_data, &block)
        template = ::Tilt.new(actual_layout)
        template.render(self, merged_data(additional_data)) do
          block.call
        end
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
    end
  end
end
