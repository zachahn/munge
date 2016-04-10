require "test_helper"

class ItemTest < TestCase
  def new_item(type:        :text,
               relpath:     "path/to/index.html.erb",
               id:          "path/to",
               content:     %(<%= "hi" %>\n),
               frontmatter: {},
               stat:        nil)
    Munge::Item.new(
      type:        type,
      relpath:     relpath,
      id:          id,
      content:     content,
      frontmatter: frontmatter,
      stat:        stat
    )
  end

  def test_accessors
    item = new_item

    assert_equal(:text, item.type)
    assert_equal("path/to/index.html.erb", item.relpath)
    assert_equal("path/to", item.id)
    assert_equal(%(<%= "hi" %>\n), item.content)
    assert_equal({}, item.frontmatter)
    assert_equal(nil, item.stat)
  end

  def test_dirname
    item = new_item(relpath: "index.html")
    assert_equal "", item.dirname

    item = new_item(relpath: "in/sub/dir.html.erb")
    assert_equal "in/sub", item.dirname
  end

  def test_filename
    item = new_item(relpath: "index.html.erb")
    assert_equal "index.html.erb", item.filename

    item = new_item(relpath: "in/sub/dir.html.erb")
    assert_equal "dir.html.erb", item.filename
  end

  def test_basename
    item = new_item(relpath: "index.html.erb")
    assert_equal "index", item.basename

    item = new_item(relpath: "in/sub/dir.html.erb")
    assert_equal "dir", item.basename
  end

  def test_extensions
    item = new_item(relpath: "index.html.erb")
    assert_equal %w(html erb), item.extensions

    item = new_item(relpath: "lol")
    assert_equal [], item.extensions
  end

  def test_route_set_get
    item = new_item(relpath: "index.html.erb")

    assert_equal nil, item.route

    item.route = "foo"
    assert_equal "/foo", item.route

    item.route = "/bar/"
    assert_equal "/bar", item.route

    item.route = "/////baz/"
    assert_equal "/baz", item.route
  end

  def test_route?
    item = new_item

    assert_equal false, item.route?("test")

    item.route = "test"
    assert_equal true, item.route?("test")
    assert_equal false, item.route?("fail")
  end

  def test_relpath?
    item = new_item
    assert_equal true, item.relpath?("")
    assert_equal false, item.relpath?("test")

    item = new_item(relpath: "in/sub/dir.html.erb")

    assert_equal true, item.relpath?("in")
    assert_equal true, item.relpath?("in", "sub")
    assert_equal true, item.relpath?("in", "sub", "dir")
    assert_equal true, item.relpath?("\\w")
    assert_equal false, item.relpath?("\\d")
    assert_equal false, item.relpath?("not")
    assert_equal false, item.relpath?("sub")
    assert_equal false, item.relpath?("dir")
  end

  def test_frontmatter
    item = new_item

    assert_equal nil, item.frontmatter[:foo]

    item.frontmatter[:foo] = "hi"
    assert_equal "hi", item.frontmatter[:foo]
    assert_equal "hi", item[:foo]

    item[:test] = "bye"
    assert_equal "bye", item.frontmatter[:test]
  end

  def test_transformations
    item = new_item
    item.transform
    assert_equal [[:tilt, []]], item.transforms

    item = new_item
    item.transform(:Asdf, "gh", j: "kl")
    item.transform(:qwer, "ty", "uiop")
    assert_equal [:Asdf, ["gh", j: "kl"]], item.transforms[0]
    assert_equal [:qwer, %w(ty uiop)], item.transforms[1]
  end

  def test_layout=
    item = new_item

    assert_equal nil, item.layout

    item.layout = "foo"
    assert_equal "foo", item.layout

    item.layout = "/bar/"
    assert_equal "bar", item.layout

    item.layout = "/////baz/"
    assert_equal "baz", item.layout
  end

  def test_frozen_items
    item = new_item

    item.layout = "old"

    item.freeze

    assert_raises(RuntimeError) { item.layout = "new" }
    assert_raises(RuntimeError) { item.layout << "lol" }
  end
end
