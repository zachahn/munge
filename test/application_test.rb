require "test_helper"

class ApplicationTest < Minitest::Test
  def test_source
    system = Minitest::Mock.new
    system.expect(:source, nil, [])

    application = Munge::Application.new(system)

    application.source

    system.verify
  end

  def test_write
    item = Minitest::Mock.new
    item.expect(:route, "index")

    system = OpenStruct.new
    system.source = [item]
    system.router = Minitest::Mock.new
    system.router.expect(:filepath, "/path/to/index", [item])
    system.alterant = Minitest::Mock.new
    system.alterant.expect(:transform, "lipstique", [item])
    system.writer = Minitest::Mock.new
    system.writer.expect(:write, true, ["/path/to/index", "lipstique"])

    application = Munge::Application.new(system)

    application.write do |_yielded_item, write_status|
      assert_equal true, write_status
    end

    item.verify
    system.router.verify
    system.alterant.verify
    system.writer.verify
  end

  def test_build_virtual_item
    system = OpenStruct.new
    system.source = Minitest::Mock.new
    system.source.expect(:build, "built item", [{ relpath: "new-item-relpath", content: "new item content", frontmatter: { this: "is frontmatter" } }])

    application = Munge::Application.new(system)

    application.build_virtual_item("new-item-relpath", "new item content", this: "is frontmatter")

    system.source.verify
  end

  def test_create
    system = OpenStruct.new
    system.source = Minitest::Mock.new
    system.source.expect(:build, "built item", [{ relpath: "new-item-relpath", content: "new item content", frontmatter: { this: "is frontmatter" } }])
    system.source.expect(:push, nil, ["built item"])

    application = Munge::Application.new(system)

    application.create("new-item-relpath", "new item content", this: "is frontmatter") do |item|
      assert_equal "built item", item
    end

    system.source.verify
  end
end
