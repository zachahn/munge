require "test_helper"

class SystemRouterItemishTest < TestCase
  def test_compiled_content
    item = OpenStruct.new

    processor = Minitest::Mock.new
    processor.expect(:transform, "postcompile", [item])

    itemish = Munge::System::Router::Itemish.new(item, processor)
    itemish.compiled_content

    processor.verify
  end

  def test_delegated_method
    item = Minitest::Mock.new
    item.expect(:frontmatter, {})

    processor =
      QuickDummy.new(
        transform: -> (_item) { "postcompile" }
      )

    itemish = Munge::System::Router::Itemish.new(item, processor)
    itemish.frontmatter

    item.verify
  end
end
