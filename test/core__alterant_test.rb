require "test_helper"

class CoreAlterantTest < Minitest::Test
  def setup
    @alterant = Munge::Core::Alterant.new(scope: Object.new)

    @rot13 = Object.new

    def @rot13.name
      :rot13
    end

    def @rot13.call(item, content, *)
      content.tr("a-z", "n-za-m")
    end

    @double = Object.new

    def @double.name
      :double
    end

    def @double.call(item, content, *)
      content + content
    end
  end

  def test_registration_disallows_transformers_with_same_name
    @alterant.register(@rot13)

    assert_raises(RuntimeError) { @alterant.register(@rot13) }
  end

  def test_transform
    @alterant.register(@rot13)

    item = OpenStruct.new
    item.transforms = [[:rot13]]
    item.content = %(hello)

    output = @alterant.transform(item)

    assert_equal "uryyb", output
  end

  def test_multiple_transforms
    @alterant.register(@rot13)
    @alterant.register(@double)

    item = OpenStruct.new
    item.transforms = [[:rot13], [:double]]
    item.content = %(hello)

    output = @alterant.transform(item)

    assert_equal "uryyburyyb", output
  end
end
