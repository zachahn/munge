module Munge
  module Transformer
    class ImageOptim
      def initialize(_scope_factory)
      end

      def call(item, content = nil, **initialization)
        actual_content =
          if content.nil?
            item.content
          else
            content
          end

        optimizer = ::ImageOptim.new(**initialization)
        optimizer.optimize_image_data(actual_content)
      end
    end
  end
end
