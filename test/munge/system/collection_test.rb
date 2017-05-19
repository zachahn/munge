require "test_helper"

class SystemCollectionTest < TestCase
  test "hashlike access" do
    items = new_collection
    item = items["id doge.html"]

    assert_equal("cool", item[:frontmatter][:super])
  end

  test "#[] not found" do
    items = new_collection
    assert_raises(Munge::Error::ItemNotFoundError) { items["id notfound.html"] }
  end

  test "#each returns enumerator" do
    items = new_collection
    assert_kind_of(Enumerator, items.each)
  end

  test "#each enumerator includes correct items" do
    items = new_collection
    item1 = OpenStruct.new(
      id: "id lol.html",
      content: "cool",
      frontmatter: { super: "cool" }
    )
    item2 = OpenStruct.new(
      id: "id doge.html",
      content: "",
      frontmatter: { super: "cool" }
    )

    assert_includes(items.each.to_a, item1)
    assert_includes(items.each.to_a, item2)
    assert_equal(2, items.each.to_a.size)
  end

  test "#push adds an item into collection" do
    items = new_collection
    item = OpenStruct.new(
      id: "id foo/bar.jpg",
      content: "binary content lol",
      frontmatter: {}
    )

    items.push(item)

    assert_equal(3, items.each.to_a.size)
    assert_includes(items.each.to_a, item)
  end

  test "#push prevents duplicate item ids" do
    items = new_collection
    item1 = OpenStruct.new(
      id: "id foo.txt",
      content: "qqqq",
      frontmatter: {}
    )
    item2 = OpenStruct.new(
      id: "id foo.txt",
      content: "wwww",
      frontmatter: {}
    )
    items.push(item1)

    assert_raises(Munge::Error::DuplicateItemError) do
      items.push(item2)
    end
  end

  test "#freeze freezes deeply" do
    items = new_collection
    items.freeze

    assert_raises(RuntimeError) do
      items.push(
        OpenStruct.new(
          id: "id foo/bar.jpg",
          content: "binary content lol",
          frontmatter: {}
        )
      )
    end
  end

  private

  def new_collection
    Munge::System::Collection.new(
      items: [
        OpenStruct.new(id: "id lol.html", content: "cool", frontmatter: { super: "cool" }),
        OpenStruct.new(id: "id doge.html", content: "", frontmatter: { super: "cool" })
      ]
    )
  end
end
