require "test_helper"

class SystemProcessorTest < TestCase
  def setup
    @processor = Munge::System::Processor.new
  end

  def test_registration_disallows_transformers_with_same_name
    register_rot13!

    assert_raises(Munge::Errors::DuplicateTransformerError) { @processor.register(@rot13) }
  end

  def test_transform
    register_rot13!

    item = OpenStruct.new
    item.transforms = [[:rot13]]
    item.content = %(hello)

    output = @processor.transform(item)

    assert_equal "uryyb", output
  end

  def test_multiple_transforms
    register_rot13!
    retister_double!

    item = OpenStruct.new
    item.transforms = [[:rot13], [:double]]
    item.content = %(hello)

    output = @processor.transform(item)

    assert_equal "uryyburyyb", output
  end

  def test_missing_transformer
    item = OpenStruct.new
    item.transforms = [[:dne], [:rot13]]
    item.content = %(hello)

    assert_raises(Munge::Errors::TransformerNotFoundError) { @processor.transform(item) }
  end

  private

  def register_rot13!
    @rot13 =
      QuickDummy.new(
        name: -> { :rot13 },
        call: -> (_item, content, *) { content.tr("a-z", "n-za-m") }
      )

    @processor.register(@rot13)
  end

  def retister_double!
    @double =
      QuickDummy.new(
        name: -> { :double },
        call: -> (_item, content, *) { content + content }
      )

    @processor.register(@double)
  end
end
