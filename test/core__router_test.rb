require "test_helper"

class CoreRouterTest < Minitest::Test
  def setup
    @router = new_router
  end

  def new_item(relpath, type: :text, id: nil)
    Munge::Item.new(
      type: :text,
      relpath: relpath,
      id: id || relpath.split(".").first,
      content: ""
    )
  end

  def new_router(index_extensions: nil, index_basename: nil)
    config = Munge::Core::Config.new(File.join(example_path, "config.yml"))

    Munge::Core::Router.new(
      index:           config[:index],
      keep_extensions: config[:keep_extensions]
    )
  end

  def test_route_index_html_page
    item       = new_item("index.html.erb")
    item.route = ""

    assert_equal "/", @router.route(item)
  end

  def test_route_about_html_page
    item       = new_item("about.html.md.erb")
    item.route = "about"

    assert_equal "/about", @router.route(item)
  end

  def test_relpath_index_html_page
    item       = new_item("index.html.erb")
    item.route = ""

    assert_equal "index.html", @router.filepath(item)
  end

  def test_relpath_about_html_page
    item       = new_item("index.html.erb")
    item.route = "about"

    assert_equal "about/index.html", @router.filepath(item)
  end

  def test_relpath_gif
    item = new_item("transparent.gif")
    item.route = "t"

    assert_equal "t.gif", @router.filepath(item)
  end

  def test_route_gif
    item = new_item("transparent.gif")
    item.route = "t"

    assert_equal "/t.gif", @router.route(item)
  end

  def test_set_route_with_relpath
    item = new_item("transparent.gif")
    item.route = item.relpath

    assert_equal "/transparent.gif", @router.route(item)
  end
end
