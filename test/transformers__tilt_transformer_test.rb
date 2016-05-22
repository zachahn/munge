require "test_helper"

class TransformersTiltTransformerTest < TestCase
  include TransformerInterfaceTest

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

  test "can pass in rendering options" do
    @tilt_transformer.demand(Tilt::ScssTemplate, style: :compressed)

    output = @tilt_transformer.call(new_item, "a { color: black }", "scss")

    assert_equal "a{color:#000}\n", output
  end

  private

  def new_item
    OpenStruct.new(
      frontmatter: {},
      content: %(<%= "hi" %>)
    )
  end

  def transformer
    fake_scope = Object.new
    fake_scope.instance_variable_set(:@global_data, {})

    Munge::Transformers::TiltTransformer.new(fake_scope)
  end
end
