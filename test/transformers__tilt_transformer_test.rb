require "test_helper"

class TransformersTiltTransformerTest < TestCase
  include TransformerInterfaceTest

  test "auto transform" do
    tilt_transformer = new_transformer_with_rendering

    item = new_item
    item.relpath = "foo.erb"

    output = tilt_transformer.call(item, new_item_content)

    assert_equal("hi", output)
  end

  test "manual transform" do
    tilt_transformer = new_transformer_with_rendering

    item = new_item
    item.relpath = "foo.txt"

    output = tilt_transformer.call(item, new_item_content, "erb")

    assert_equal("hi", output)
  end

  test "can pass in rendering options" do
    tilt_transformer = new_transformer_with_rendering
    tilt_transformer.demand(Tilt::ScssTemplate, style: :compressed)

    output = tilt_transformer.call(new_item, "a { color: black }", "scss")

    assert_equal("a{color:#000}\n", output)
  end

  private

  def new_item_content
    %(<%= "hi" %>)
  end

  def new_item
    OpenStruct.new(
      frontmatter: {},
      content: new_item_content
    )
  end

  def new_transformer
    inspector = noop_inspector
    fake_scope = Object.new
    fake_scope.define_singleton_method(:global_data) { Hash.new }
    fake_scope.define_singleton_method(:inspector) { inspector }

    Munge::Transformers::TiltTransformer.new(fake_scope)
  end

  def new_transformer_with_rendering
    transformer = new_transformer
    transformer.register(Munge::Helpers::Rendering)
    transformer
  end
end
