require "test_helper"

class SystemCollectionTest < TestCase
  test "hashlike access" do
    items = new_collection(new_item_factory)
    item = items["id doge.html"]

    assert_equal("cool", item[:frontmatter][:super])
  end

  test "#[] not found" do
    items = new_collection(new_item_factory)
    assert_raises(Munge::Errors::ItemNotFoundError) { items["id notfound.html"] }
  end

  test "#each returns enumerator" do
    items = new_collection(new_item_factory)
    assert_kind_of(Enumerator, items.each)
  end

  test "#each enumerator includes correct items" do
    items = new_collection(new_item_factory)
    item1 = { relpath: "lol.html", content: "cool", frontmatter: { super: "cool" } }
    item2 = { relpath: "doge.html", content: "", frontmatter: { super: "cool" } }

    assert_includes(items.each.to_a, item1)
    assert_includes(items.each.to_a, item2)
    assert_equal(2, items.each.to_a.size)
  end

  test "#build returns an item" do
    items = new_collection(new_item_factory)
    item =
      items.build(
        relpath: "foo/bar.jpg",
        content: "binary content lol",
        frontmatter: {}
      )

    assert_equal("id foo/bar.jpg", item.id)
    assert_equal("foo/bar.jpg", item[:relpath])
    assert_equal("binary content lol", item[:content])
    assert_equal({}, item[:frontmatter])
  end

  test "#build silently ignores extraneous params" do
    items = new_collection(new_item_factory)
    item =
      items.build(
        relpath: "foo/bar.jpg",
        content: "binary content lol",
        frontmatter: {},
        unused: "param"
      )

    assert_nil(item[:unused])
  end

  test "#push adds an item into collection" do
    items = new_collection(new_item_factory)
    item_params = {
      relpath: "foo/bar.jpg",
      content: "binary content lol",
      frontmatter: {}
    }

    item = items.build(**item_params)

    items.push(item)

    assert_equal(3, items.each.to_a.size)
    assert_includes(items.each.to_a, item_params)
    assert_equal("binary content lol", items["id foo/bar.jpg"][:content])
  end

  test "#push prevents duplicate item ids" do
    items = new_collection(new_item_factory)
    item1 = items.build(relpath: "foo.txt", content: "qqqq", frontmatter: {})
    item2 = items.build(relpath: "foo.txt", content: "wwww", frontmatter: {})

    items.push(item1)

    assert_raises(Munge::Errors::DuplicateItemError) do
      items.push(item2)
    end
  end

  test "#freeze freezes deeply" do
    items = new_collection(new_item_factory)
    items.freeze

    assert_raises(RuntimeError) do
      items.push(
        items.build(
          relpath: "foo/bar.jpg",
          content: "binary content lol",
          frontmatter: {}
        )
      )
    end
  end

  private

  def new_item_factory
    QuickDummy.new(
      build: lambda do |args|
        args.define_singleton_method(:id) { "id #{self[:relpath]}" }
        args
      end,
      parse: lambda do |**args|
        args[:frontmatter] = {}
        args[:frontmatter][:super] = "cool"
        build(args)
      end
    )
  end

  def new_collection(item_factory)
    Munge::System::Collection.new(
      item_factory: item_factory,
      items: [
        { relpath: "lol.html", content: "cool" },
        { relpath: "doge.html", content: "" }
      ]
    )
  end
end
