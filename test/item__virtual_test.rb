require "test_helper"

class ItemVirtualTest < Minitest::Test
  def setup
    @item = Munge::Item::Virtual.new(
      "virtual/relpath.html.erb",
      Munge::Attribute::Content.new("lol", "one and one" => 2)
    )
  end

  def test_alternate_initialize
    item = Munge::Item::Virtual.new(
      "virtual/relpath.txt",
      "super cool content",
      key: "value"
    )

    assert_equal "super cool content", item.content
    assert_equal "value", item.frontmatter[:key]
    assert_equal "virtual/relpath", item.id
  end

  def test_item_paths
    assert_equal "virtual/relpath.html.erb", @item.relpath
    assert_equal "virtual", @item.dirname
    assert_equal "relpath.html.erb", @item.filename
    assert_equal "relpath", @item.basename
    assert_equal "virtual/relpath", @item.id
  end

  def test_item_is_writable
    @item.content = "foo"

    assert_equal "foo", @item.content
  end

  def test_item_type_is_virtual
    assert_equal true, @item.virtual?
  end

  def test_content_and_frontmatter
    assert_equal 2, @item.frontmatter["one and one"]
    assert_equal "lol", @item.content
  end
end
