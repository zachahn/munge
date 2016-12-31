require "test_helper"

class SystemRouterItemishTest < TestCase
  test "compiled content" do
    item = OpenStruct.new

    processor = Minitest::Mock.new
    processor.expect(:transform, "postcompile", [item])

    itemish = Munge::System::Router::Itemish.new(item, processor)
    itemish.compiled_content

    processor.verify
  end

  test "delegated method" do
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
