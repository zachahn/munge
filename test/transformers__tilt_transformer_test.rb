require "test_helper"

class TransformersTiltTransformerTest < TestCase
  def setup
    fake_scope = Object.new
    fake_scope.instance_variable_set(:@global_data, {})

    @tilt_transformer = Munge::Transformers::TiltTransformer.new(fake_scope)
    @tilt_transformer.register(Munge::Helpers::Rendering)
  end

  def test_auto_transform
    item = new_item
    item.relpath = "foo.erb"
    output = @tilt_transformer.call(item)

    assert_equal "hi", output
  end

  def test_manual_transform
    item = new_item
    item.relpath = "foo.txt"
    output = @tilt_transformer.call(item, nil, "erb")

    assert_equal "hi", output
  end

  private

  def new_item
    OpenStruct.new(
      frontmatter: {},
      content: %(<%= "hi" %>)
    )
  end
end
