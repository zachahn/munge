require "test_helper"

class CoreRouterItemishTest < Minitest::Test
  def test_compiled_content
    item = OpenStruct.new

    alterant = Minitest::Mock.new
    alterant.expect(:transform, "postcompile", [item])

    itemish = Munge::Core::Router::Itemish.new(item, alterant)
    itemish.compiled_content

    alterant.verify
  end

  def test_delegated_method
    item = Minitest::Mock.new
    item.expect(:frontmatter, {})

    alterant =
      QuickDummy.new(
        transform: -> (_item) { "postcompile" }
      )

    itemish = Munge::Core::Router::Itemish.new(item, alterant)
    itemish.frontmatter

    item.verify
  end
end
