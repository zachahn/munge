module Munge
  module Transformer
    class Tilt
      class TiltItemRenderer
        def initialize(layouts_path, global_data)
          @global_data  = global_data
          @layouts_path = layouts_path
        end

        def render(item, manual_renderer = nil, **additional_data, &content_block)
          content   = resolve_render_content(item, &content_block)
          renderers = resolve_render_renderer(item, manual_renderer)

          renderers
            .inject(content) do |output, engine|
              template = engine.new { output }
              template.render(self, merged_data(item.frontmatter, additional_data))
            end
        end

        def layout(path, **additional_data, &block)
          actual_layout = find_layout(path)

          if block.binding.local_variable_defined?(:_erbout)
            layout_within_template(actual_layout, additional_data, &block)
          else
            layout_outside_template(actual_layout, additional_data, &block)
          end
        end

        def render_with_layout(item, **additional_data)
          layout(item.layout, additional_data) do
            render(item, additional_data)
          end
        end

        private

        def merged_data(*data)
          data.inject(@global_data) do |merged, datum|
            merged.merge(datum)
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

        def resolve_render_content(item, &content_block)
          if block_given?
            content_block.call
          else
            item.content
          end
        end

        def resolve_render_renderer(item, manual_renderer)
          if manual_renderer.nil?
            ::Tilt.templates_for(item.relpath)
          else
            [::Tilt[manual_renderer]].compact
          end
        end
      end
    end
  end
end
