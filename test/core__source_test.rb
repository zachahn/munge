require "test_helper"

class CoreSourceTest < Minitest::Test
  def setup
    @item_factory = Object.new

    def @item_factory.build(**args)
      def args.id
        "id #{self[:relpath]}"
      end

      args
    end

    @source = Munge::Core::Source.new(
      item_factory: @item_factory,
      items: [
        { relpath: "lol.html", content: "cool", frontmatter: {} },
        { relpath: "doge.html", content: "", frontmatter: { much: "cool" } }
      ]
    )
  end

  def test_hashlike_access
    item = @source["id doge.html"]

    assert_equal "cool", item[:frontmatter][:much]
  end

  def test_each_returns_enumerator
    assert_kind_of(Enumerator, @source.each)
  end

  def test_enumerator_includes_correct_items
    item1 = { relpath: "lol.html", content: "cool", frontmatter: {} }
    item2 = { relpath: "doge.html", content: "", frontmatter: { much: "cool" } }

    assert_includes @source.each.to_a, item1
    assert_includes @source.each.to_a, item2
    assert_equal 2, @source.each.to_a.count
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
    assert_equal Hash.new, item[:frontmatter]
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
    item =
      @source.build(
        relpath: "foo/bar.jpg",
        content: "binary content lol",
        frontmatter: {}
      )

    @source.push(item)

    assert_equal 3, @source.each.to_a.count
    assert_includes @source.each.to_a, { relpath: "foo/bar.jpg", content: "binary content lol", frontmatter: {} }
    assert_equal "binary content lol", @source["id foo/bar.jpg"][:content]
  end
end
