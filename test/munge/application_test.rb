require "test_helper"

class ApplicationTest < TestCase
  test "#items" do
    conglomerate = Minitest::Mock.new
    conglomerate.expect(:items, nil, [])

    application = Munge::Application.new(conglomerate)

    application.items

    conglomerate.verify
  end

  test "#build_virtual_item" do
    expected_args = { relpath: "relpath", content: "new content", frontmatter: { cool: "frontmatter" } }

    conglomerate = OpenStruct.new
    conglomerate.item_factory = Minitest::Mock.new
    conglomerate.item_factory.expect(:build, "built item", [expected_args])

    application = Munge::Application.new(conglomerate)

    application.build_virtual_item("relpath", "new content", cool: "frontmatter")

    conglomerate.item_factory.verify
  end

  test "#create" do
    expected_args = { relpath: "relpath", content: "new content", frontmatter: { cool: "frontmatter" } }

    conglomerate = OpenStruct.new
    conglomerate.item_factory = Minitest::Mock.new
    conglomerate.item_factory.expect(:build, "built item", [expected_args])
    conglomerate.items = Minitest::Mock.new
    conglomerate.items.expect(:push, nil, ["built item"])

    application = Munge::Application.new(conglomerate)

    item = application.create("relpath", "new content", cool: "frontmatter")

    assert_equal("built item", item[0])

    conglomerate.items.verify
    conglomerate.item_factory.verify
  end

  test "#create returns Enumerable" do
    conglomerate = OpenStruct.new
    conglomerate.item_factory =
      QuickDummy.new(
        build: -> (_) { "item" }
      )
    conglomerate.items =
      QuickDummy.new(
        push: -> (_) {}
      )

    application = Munge::Application.new(conglomerate)

    enum_item =
      application
        .create("test.html", "<div>content</div>")
        .each

    assert_instance_of(Enumerator, enum_item)
    assert_equal(1, enum_item.size)
  end

  test "items with false routes don't show up in #routed or #nonrouted" do
    yes_item = OpenStruct.new(route: "yes")
    nil_item = OpenStruct.new(route: nil)
    false_item = OpenStruct.new(route: false)
    conglomerate = OpenStruct.new(items: [yes_item, nil_item, false_item])
    application = Munge::Application.new(conglomerate)

    assert_includes(application.routed.map(&:route), "yes")
    refute_includes(application.routed.map(&:route), nil)
    refute_includes(application.routed.map(&:route), false)

    refute_includes(application.nonrouted.map(&:route), "yes")
    assert_includes(application.nonrouted.map(&:route), nil)
    refute_includes(application.nonrouted.map(&:route), false)
  end
end
