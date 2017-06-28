require "test_helper"

class SystemProcessorTest < TestCase
  test "transform" do
    processor = Munge::System::Processor.new
    processor.register(:capitalize, to: CapitalizeTransformer)

    item = new_item(:capitalize)

    output = processor.transform(item)

    assert_equal("Hello", output)
  end

  test "multiple transforms" do
    processor = Munge::System::Processor.new
    processor.register(:double, to: DoublerTransformer)
    processor.register(:capitalize, to: CapitalizeTransformer)

    item = new_item(:double, :capitalize)

    output = processor.transform(item)

    assert_equal("Hellohello", output)
  end

  private

  class DoublerTransformer
    def initialize(_filename, memo)
      @memo = memo
    end

    def render(_view_scope, &_block)
      @memo + @memo
    end
  end

  class CapitalizeTransformer
    def initialize(_filename, memo)
      @memo = memo
    end

    def render(_view_scope, &_block)
      @memo.capitalize
    end
  end

  def new_item(*transformations)
    item = OpenStruct.new
    item.transforms = transformations.map(&:to_sym)
    item.content = %(hello)
    item
  end
end
