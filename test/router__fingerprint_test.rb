require "test_helper"

class RouterFingerprintTest < Minitest::Test
  def setup
    @router = Munge::Core::Router.new(alterant: new_dummy_alterant)

    @router.register(Munge::Router::Fingerprint.new(extensions: %w(gif)))
  end

  def new_item(relpath, type: :text, id: nil)
    Munge::Item.new(
      type: :text,
      relpath: relpath,
      id: id || relpath.split(".").first,
      content: ""
    )
  end

  def new_dummy_alterant
    alterant = Object.new

    def alterant.transform(item)
      "dummy transformed text"
    end

    alterant
  end

  def test_route_without_hashing_because_of_extension
    item       = new_item("index.html.erb")
    item.route = "index.html"

    assert_equal "/index.html", @router.route(item)
    assert_equal "index.html", @router.filepath(item)
  end

  def test_route_with_hashing
    item = new_item("transparent.gif")
    item.route = item.relpath

    assert_equal "/transparent--521ffffcb84d29ac6fc19f869eee5057.gif", @router.route(item)
    assert_equal "transparent--521ffffcb84d29ac6fc19f869eee5057.gif", @router.filepath(item)
  end

  def test_fingerprintable_route_but_is_unfingerprinted
    item = new_item("transparent.gif")
    item.route = item.relpath
    item.frontmatter[:fingerprint_asset] = false

    assert_equal "/transparent.gif", @router.route(item)
    assert_equal "transparent.gif", @router.filepath(item)
  end
end
