require "test_helper"

class IntegrationRouterTest < Minitest::Test
  def setup
    fingerprint = Munge::Router::Fingerprint.new(extensions: %w(gif))
    index_html = Munge::Router::AddIndexHtml.new(html_extensions: %w(html), index: "index.html")
    auto_add_extension = Munge::Router::AutoAddExtension.new(keep_extensions: %w(gif))

    alterant = QuickDummy.new(transform: -> (_item) { "transformed" })

    @router = Munge::Core::Router.new(alterant: alterant)

    @router.register(fingerprint)
    @router.register(index_html)
    @router.register(auto_add_extension)
  end

  def new_item(relpath, type: :text, id: nil)
    Munge::Item.new(
      type: type,
      relpath: relpath,
      id: id || relpath.split(".").first,
      content: ""
    )
  end

  def test_index
    item = new_item("about.html.erb")
    item.route = "about"

    assert_equal "/about", @router.route(item)
    assert_equal "about/index.html", @router.filepath(item)
  end

  def test_gif_when_route_has_extension
    item = new_item("t.gif")
    item.route = "t.gif"

    assert_equal "/t--6090a18fd9a2e25d11957dacdcdfcb23.gif", @router.route(item)
    assert_equal "t--6090a18fd9a2e25d11957dacdcdfcb23.gif", @router.filepath(item)
  end

  def test_gif_when_route_has_no_extension
    item = new_item("t.gif")
    item.route = "t"

    assert_equal "/t--6090a18fd9a2e25d11957dacdcdfcb23.gif", @router.route(item)
    assert_equal "t--6090a18fd9a2e25d11957dacdcdfcb23.gif", @router.filepath(item)
  end
end
