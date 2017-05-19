require "test_helper"

class IntegrationRouterTest < TestCase
  test "index" do
    router = new_router
    item = new_item("about.html.erb")
    item.route = "about"

    assert_equal("/about", router.route(item))
    assert_equal("about/index.html", router.filepath(item))
  end

  test "fingerprinting when route has extension" do
    router = new_router
    item = new_item("t.gif")
    item.route = "t.gif"

    assert_equal("/t--#{fingerprint_value}.gif", router.route(item))
    assert_equal("t--#{fingerprint_value}.gif", router.filepath(item))
  end

  test "fingerprinting when route has no extension" do
    router = new_router
    item = new_item("t.gif")
    item.route = "t"

    assert_equal("/t--#{fingerprint_value}.gif", router.route(item))
    assert_equal("t--#{fingerprint_value}.gif", router.filepath(item))
  end

  test "index thing" do
    router = new_router
    item = new_item("index.html.erb")
    item.route = "index"

    assert_equal("/", router.route(item))
    assert_equal("index.html", router.filepath(item))
  end

  private

  def fingerprint_value
    "6517eaddaaeaf31a1de9b77c3a284e5862f4c75ae7bc2ce261c10cbeafdc5fa5"
  end

  def new_item(relpath, type: :text, id: nil)
    Munge::Item.new(
      type: type,
      relpath: relpath,
      id: id || relpath.split(".").first,
      content: ""
    )
  end

  def new_router
    fingerprint = Munge::Router::Fingerprint.new(extensions: %w(gif), separator: "--")
    index_basename = Munge::Router::RemoveBasename.new(extensions: %w(html), basenames: %w(index), keep_explicit: true)
    index_html = Munge::Router::AddDirectoryIndex.new(extensions: %w(html), index: "index.html")
    auto_add_extension = Munge::Router::AutoAddExtension.new(keep_extensions: %w(gif))

    processor = QuickDummy.new(transform: -> (_item) { "transformed" })

    router = Munge::System::Router.new(processor: processor)
    router.register(fingerprint)
    router.register(index_basename)
    router.register(index_html)
    router.register(auto_add_extension)
    router
  end
end
