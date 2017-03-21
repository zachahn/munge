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
    item = OpenStruct.new(frontmatter: { og: :frontmatter })

    processor =
      QuickDummy.new(
        transform: -> (_item) { "postcompile" }
      )

    itemish = Munge::System::Router::Itemish.new(item, processor)
    assert_equal({ og: :frontmatter }, itemish.frontmatter)
  end
end
