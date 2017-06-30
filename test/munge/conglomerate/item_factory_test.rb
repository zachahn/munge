require "test_helper"

class ConglomerateItemFactoryTest < TestCase
  test "#build text item" do
    item_factory = new_item_factory

    item = item_factory.build(
      relpath: "path/to/index.html",
      content: "this is so cool man",
      frontmatter: { foo: "bar" }
    )

    assert_equal(true, item.text?)
    assert_equal("this is so cool man", item.content)
    assert_equal("bar", item.frontmatter[:foo])
  end

  test "#build binary item" do
    item_factory = new_item_factory

    item = item_factory.build(
      relpath: "path/to/picture.gif",
      content: "",
      frontmatter: { foo: "bar" }
    )

    assert_equal(true, item.binary?)
    assert_equal("bar", item.frontmatter[:foo])
  end

  test "#build text item with no extensions" do
    item_factory =
      Munge::Conglomerate::ItemFactory.new(
        text_extensions: %w(txt md html),
        ignore_extensions: %w(.+)
      )

    item = item_factory.build(relpath: "index.html", content: "")
    assert_equal("index", item.id)

    item = item_factory.build(relpath: "path/to/dir.gif", content: "")
    assert_equal("path/to/dir", item.id)
  end

  test "#build binary items creates ids with one extension" do
    item_factory = new_item_factory

    item = item_factory.build(relpath: "index.gif", content: "")
    assert_equal("index.gif", item.id)

    item = item_factory.build(relpath: "path/to/dir.gif", content: "")
    assert_equal("path/to/dir.gif", item.id)

    item = item_factory.build(relpath: "index.html.erb", content: "")
    assert_equal("index.html", item.id)

    item = item_factory.build(relpath: "frontmatter.html.erb", content: "")
    assert_equal("frontmatter.html", item.id)

    item = item_factory.build(relpath: "in/sub/dir.html.erb", content: "")
    assert_equal("in/sub/dir.html", item.id)
  end

  test "#build builds item with the correct type" do
    item_factory = new_item_factory

    txt = item_factory.build(relpath: "index.html", content: "")
    assert_equal(true, txt.text?)

    bin = item_factory.build(relpath: "transparent.gif", content: "")
    assert_equal(true, bin.binary?)
  end

  test "#parse" do
    item_factory = new_item_factory

    content_with_frontmatter = "---\nhas: frontmatter\n---\n\nmain content"
    txt = item_factory.parse(relpath: "index.html", content: content_with_frontmatter)
    assert_equal("main content", txt.content)
    assert_equal("frontmatter", txt.frontmatter[:has])

    bin = item_factory.parse(relpath: "transparent.gif", content: content_with_frontmatter)
    assert_equal(content_with_frontmatter, bin.content)
    assert_equal({}, bin.frontmatter)
  end

  private

  def new_item_factory
    Munge::Conglomerate::ItemFactory.new(
      text_extensions: %w(txt md html),
      ignore_extensions: %w(erb)
    )
  end
end
