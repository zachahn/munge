module Munge
  module Transformer
    class Tilt
      class Renderer
        def initialize
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

        private

        def list_of_engines(item, preferred_engines)
          engines_as_path =
            if preferred_engines
              if preferred_engines.is_a?(Array)
                preferred_engines.flatten.join(".")
              else
                preferred_engines
              end
            else
              item.relpath
            end
          
          ::Tilt.templates_for(engines_as_path)
        end

        def merge_data_with_global(*datasets)
          hash_with_string_and_symbol_keys =
            datasets.inject(@global_data) do |merged, dataset|
              merged.merge(dataset)
            end

          hash_with_string_and_symbol_keys
            .each_with_object({}) do |(key, value), memo|
              memo[key.to_sym] = value
            end
        end
      end
    end
  end
end
