require "test_helper"

class SystemItemFactoryTest < TestCase
  def setup
    # @item_factory = new_item_factory(ignored_basenames: %w(index dir))
    @item_factory = Munge::System::ItemFactory.new(
      text_extensions: %w(txt md html),
      ignore_extensions: %w(erb)
    )
  end

  def test_build_when_item_is_text
    item = @item_factory.build(
      relpath: "path/to/index.html",
      content: "this is so cool man",
      frontmatter: { foo: "bar" }
    )

    assert_equal :text, item.type
    assert_equal "this is so cool man", item.content
    assert_equal "bar", item.frontmatter[:foo]
  end

  def test_build_when_item_is_binary
    item = @item_factory.build(
      relpath: "path/to/picture.gif",
      content: "",
      frontmatter: { foo: "bar" }
    )

    assert_equal :binary, item.type
    assert_equal "bar", item.frontmatter[:foo]
  end

  def test_built_text_item_id_has_no_extensions
    item_factory =
      Munge::System::ItemFactory.new(
        text_extensions: %w(txt md html),
        ignore_extensions: %w(.+)
      )

    item = item_factory.build(relpath: "index.html", content: "")
    assert_equal "index", item.id

    item = item_factory.build(relpath: "path/to/dir.gif", content: "")
    assert_equal "path/to/dir", item.id
  end

  def test_built_binary_item_id_has_one_extensions
    item = @item_factory.build(relpath: "index.gif", content: "")
    assert_equal "index.gif", item.id

    item = @item_factory.build(relpath: "path/to/dir.gif", content: "")
    assert_equal "path/to/dir.gif", item.id

    item = @item_factory.build(relpath: "index.html.erb", content: "")
    assert_equal "index.html", item.id

    item = @item_factory.build(relpath: "frontmatter.html.erb", content: "")
    assert_equal "frontmatter.html", item.id

    item = @item_factory.build(relpath: "in/sub/dir.html.erb", content: "")
    assert_equal "in/sub/dir.html", item.id
  end

  def test_type
    txt = @item_factory.build(relpath: "index.html", content: "")
    assert_equal :text, txt.type

    bin = @item_factory.build(relpath: "transparent.gif", content: "")
    assert_equal :binary, bin.type
  end

  def test_parse
    content_with_frontmatter = "---\nhas: frontmatter\n---\n\nmain content"
    txt = @item_factory.parse(relpath: "index.html", content: content_with_frontmatter)
    assert_equal "main content", txt.content
    assert_equal "frontmatter", txt.frontmatter[:has]

    bin = @item_factory.parse(relpath: "transparent.gif", content: content_with_frontmatter)
    assert_equal content_with_frontmatter, bin.content
    assert_equal({}, bin.frontmatter)
  end
end
