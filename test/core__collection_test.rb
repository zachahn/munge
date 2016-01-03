require "test_helper"

class CoreCollectionTest < Minitest::Test
  def setup
    @item_factory =
      QuickDummy.new(
        build: -> (args) {
          args.define_singleton_method(:id) { "id #{self[:relpath]}" }
          args
        },
        parse: -> (**args) {
          args[:frontmatter] = {}
          args[:frontmatter][:super] = "cool"
          build(args)
        }
      )

    @source = Munge::Core::Collection.new(
      item_factory: @item_factory,
      items: [
        { relpath: "lol.html", content: "cool" },
        { relpath: "doge.html", content: "" }
      ]
    )
  end

  def test_hashlike_access
    item = @source["id doge.html"]

    assert_equal "cool", item[:frontmatter][:super]
  end

  def test_each_returns_enumerator
    assert_kind_of(Enumerator, @source.each)
  end

  def test_enumerator_includes_correct_items
    item1 = { relpath: "lol.html", content: "cool", frontmatter: { super: "cool" } }
    item2 = { relpath: "doge.html", content: "", frontmatter: { super: "cool" } }

    assert_includes @source.each.to_a, item1
    assert_includes @source.each.to_a, item2
    assert_equal 2, @source.each.to_a.size
  end

  def test_build
    item =
      @source.build(
        relpath: "foo/bar.jpg",
        content: "binary content lol",
        frontmatter: {}
      )

    assert_equal "id foo/bar.jpg", item.id
    assert_equal "foo/bar.jpg", item[:relpath]
    assert_equal "binary content lol", item[:content]
    assert_equal({}, item[:frontmatter])
  end

  def test_build_does_not_use_extraneous_params
    item =
      @source.build(
        relpath: "foo/bar.jpg",
        content: "binary content lol",
        frontmatter: {},
        unused: "param"
      )

    assert_nil item[:unused]
  end

  def test_push_inserts_into_collection
    item_params = {
      relpath: "foo/bar.jpg",
      content: "binary content lol",
      frontmatter: {}
    }

    item = @source.build(**item_params)

    @source.push(item)

    assert_equal 3, @source.each.to_a.size
    assert_includes @source.each.to_a, item_params
    assert_equal "binary content lol", @source["id foo/bar.jpg"][:content]
  end
end
