require "test_helper"

class SystemProcessorTest < TestCase
  test "transform" do
    processor = Munge::System::Processor.new(Object.new)
    processor.register(:capitalize, to: CapitalizeTransformer)

    item = new_item(:capitalize)

    output = processor.transform(item)

    assert_equal("Hello", output)
  end

  test "multiple transforms" do
    processor = Munge::System::Processor.new(Object.new)
    processor.register(:double, to: DoublerTransformer)
    processor.register(:capitalize, to: CapitalizeTransformer)

    item = new_item(:double, :capitalize)

    output = processor.transform(item)

    assert_equal("Hellohello", output)
  end

  test "#transform renders the layout" do
    layout = new_item(:erb)
    layout.content = "<%= yield %>!"

    system = OpenStruct.new
    system.layouts = { "foo.erb" => layout }

    processor = Munge::System::Processor.new(system)
    processor.register(:erb, to: Tilt::ERBTemplate)
    processor.register(:double, to: DoublerTransformer)
    processor.include(Munge::Helper::DefineModule.new(:system, system))

    item = new_item(:erb)
    item.layout = "foo.erb"

    output = processor.transform(item)

    assert_equal("hello!", output)
  end

  test "#engines_for converts :use_extensions into items extensions" do
    processor = Munge::System::Processor.new(Object.new)

    item = new_item(:whatsup, :use_extensions, :lol)
    item.filepath = "test.foo.bar"
    item.extensions = ["foo", "bar"]

    assert_equal([:whatsup, "bar", "foo", :lol], processor.engines_for(item))
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
