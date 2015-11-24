require "test_helper"

class TransformerTiltTest < Minitest::Test
  def setup
    fake_scope_class =
      Class.new do
        def initialize
          @global_data = {}
        end
      end

    @tilt_transformer = Munge::Transformer::Tilt.new(fake_scope_class.new)
  end

  def test_auto_transform
    item = OpenStruct.new
    item.relpath = "foo.erb"
    item.frontmatter = {}
    item.content = %(<%= "hi" %>)
    output = @tilt_transformer.call(item)

    assert_equal "hi", output
  end

  def test_manual_transform
    item = OpenStruct.new
    item.relpath = "foo.txt"
    item.frontmatter = {}
    item.content = %(<%= "hi" %>)
    output = @tilt_transformer.call(item, nil, "erb")

    assert_equal "hi", output
  end
end
