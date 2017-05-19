require "test_helper"

class SystemProcessorTest < TestCase
  test "registration disallows transformers with same name" do
    processor = Munge::System::Processor.new
    processor.register(new_transformer_rot13)

    assert_raises(Munge::Error::DuplicateTransformerError) { processor.register(new_transformer_rot13) }
  end

  test "transform" do
    processor = Munge::System::Processor.new
    processor.register(new_transformer_rot13)

    item = new_item(:rot13)

    output = processor.transform(item)

    assert_equal("uryyb", output)
  end

  test "multiple transforms" do
    processor = Munge::System::Processor.new
    processor.register(new_transformer_rot13)
    processor.register(new_transformer_doubler)

    item = new_item(:rot13, :double)

    output = processor.transform(item)

    assert_equal("uryyburyyb", output)
  end

  test "missing transformer" do
    processor = Munge::System::Processor.new

    item = new_item(:dne, :rot13)

    assert_raises(Munge::Error::TransformerNotFoundError) { processor.transform(item) }
  end

  private

  def new_transformer_rot13
    QuickDummy.new(
      name: -> { :rot13 },
      call: -> (_item, content, *) { content.tr("a-z", "n-za-m") }
    )
  end

  def new_transformer_doubler
    QuickDummy.new(
      name: -> { :double },
      call: -> (_item, content, *) { content + content }
    )
  end

  def new_item(*transformations)
    item = OpenStruct.new
    item.transforms = transformations.map { |t| [t.to_sym] }
    item.content = %(hello)
    item
  end
end
