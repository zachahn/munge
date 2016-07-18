require "test_helper"

class SystemCollectionTest < TestCase
  def setup
    @item_factory =
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

    @items = Munge::System::Collection.new(
      item_factory: @item_factory,
      items: [
        { relpath: "lol.html", content: "cool" },
        { relpath: "doge.html", content: "" }
      ]
    )
  end

  def test_hashlike_access
    item = @items["id doge.html"]

    assert_equal "cool", item[:frontmatter][:super]
  end

  def test_hashlike_access_not_found
    assert_raises(Munge::Errors::ItemNotFoundError) { @items["id notfound.html"] }
  end

  def test_each_returns_enumerator
    assert_kind_of(Enumerator, @items.each)
  end

  def test_enumerator_includes_correct_items
    item1 = { relpath: "lol.html", content: "cool", frontmatter: { super: "cool" } }
    item2 = { relpath: "doge.html", content: "", frontmatter: { super: "cool" } }

    assert_includes @items.each.to_a, item1
    assert_includes @items.each.to_a, item2
    assert_equal 2, @items.each.to_a.size
  end

  def test_build
    item =
      @items.build(
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
      @items.build(
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

    item = @items.build(**item_params)

    @items.push(item)

    assert_equal 3, @items.each.to_a.size
    assert_includes @items.each.to_a, item_params
    assert_equal "binary content lol", @items["id foo/bar.jpg"][:content]
  end

  def test_freeze
    @items.freeze

    assert_raises(RuntimeError) do
      @items.push(
        @items.build(
          relpath: "foo/bar.jpg",
          content: "binary content lol",
          frontmatter: {}
        )
      )
    end
  end
end
