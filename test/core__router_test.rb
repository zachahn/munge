require "test_helper"

class CoreRouterTest < Minitest::Test
  def setup
    @router = Munge::Core::Router.new(alterant: new_dummy_alterant)

    register_dummy_router!
  end

  def new_item(relpath, type: :text, id: nil)
    Munge::Item.new(
      type: type,
      relpath: relpath,
      id: id || relpath.split(".").first,
      content: ""
    )
  end

  def register_dummy_router!
    @dummy_router =
      QuickDummy.new(
        match?: -> (*) { true },
        route: -> (*) { "dummy/route" },
        filepath: -> (*) { "dummy/route/index.html" },
      )

    @router.register(@dummy_router)
  end

  def register_dummy_rot13_router!
    @rot13_router =
      QuickDummy.new(
        match?: -> (*) { true },
        route: -> (route, *) { route.tr("a-z", "n-za-m") },
        filepath: -> (route, *) { route.tr("a-z", "n-za-m") }
      )

    @router.register(@rot13_router)
  end

  def register_dummy_duplicate_only_route_router!
    @duplicate_router =
      QuickDummy.new(
        match?: -> (*) { true },
        filepath: -> (route, *) { route + route }
      )

    @router.register(@duplicate_router)
  end

  def new_dummy_alterant
    QuickDummy.new(transform: -> (*) { "dummy transformed text" })
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

  def test_only_run_routers_with_appropriate_method
    register_dummy_duplicate_only_route_router!

    item       = new_item("index.html.erb")
    item.route = ""

    assert_equal "/dummy/route", @router.route(item)
    assert_equal "dummy/route/index.htmldummy/route/index.html", @router.filepath(item)
  end
end
