require "test_helper"

class ApplicationTest < Minitest::Test
  def test_items
    system = Minitest::Mock.new
    system.expect(:items, nil, [])

    application = Munge::Application.new(system)

    application.items

    system.verify
  end

  def test_build_virtual_item
    system = OpenStruct.new
    system.items = Minitest::Mock.new
    system.items.expect(:build, "built item", [{ relpath: "new-item-relpath", content: "new item content", frontmatter: { this: "is frontmatter" } }])

    application = Munge::Application.new(system)

    application.build_virtual_item("new-item-relpath", "new item content", this: "is frontmatter")

    system.items.verify
  end

  def test_create
    system = OpenStruct.new
    system.items = Minitest::Mock.new
    system.items.expect(:build, "built item", [{ relpath: "new-item-relpath", content: "new item content", frontmatter: { this: "is frontmatter" } }])
    system.items.expect(:push, nil, ["built item"])

    application = Munge::Application.new(system)

    application.create("new-item-relpath", "new item content", this: "is frontmatter") do |item|
      assert_equal "built item", item
    end

    system.items.verify
  end
end
