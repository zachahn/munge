require "test_helper"

class CoreRouterTest < Minitest::Test
  def setup
    @router = Munge::Core::Router.new(alterant: new_dummy_alterant)

    register_dummy_router!
  end

  def new_item(relpath, type: :text, id: nil)
    Munge::Item.new(
      type: :text,
      relpath: relpath,
      id: id || relpath.split(".").first,
      content: ""
    )
  end

  def register_dummy_router!
    @dummy_router = Object.new

    def @dummy_router.match?(*)
      true
    end

    def @dummy_router.route(*)
      "/dummy/route"
    end

    def @dummy_router.filepath(*)
      "dummy/route/index.html"
    end

    @router.register(@dummy_router)
  end

  def register_dummy_rot13_router!
    @rot13_router = Object.new

    def @rot13_router.match?(*)
      true
    end

    def @rot13_router.route(route, *)
      route.tr("a-z", "n-za-m")
    end

    def @rot13_router.filepath(route, *)
      route.tr("a-z", "n-za-m")
    end

    @router.register(@rot13_router)
  end

  def new_dummy_alterant
    alterant = Object.new

    def alterant.transform(*)
      "dummy transformed text"
    end

    alterant
  end

  def test_route_single_router
    item       = new_item("index.html.erb")
    item.route = ""

    assert_equal "/dummy/route", @router.route(item)
  end

  def test_filepath_single_router
    item       = new_item("index.html.erb")
    item.route = ""

    assert_equal "dummy/route/index.html", @router.filepath(item)
  end

  def test_route_multiple_routers
    register_dummy_rot13_router!

    item       = new_item("index.html.erb")
    item.route = ""

    assert_equal "/qhzzl/ebhgr", @router.route(item)
  end

  def test_filepath_multiple_routers
    register_dummy_rot13_router!

    item       = new_item("index.html.erb")
    item.route = ""

    assert_equal "qhzzl/ebhgr/vaqrk.ugzy", @router.filepath(item)
  end
end
