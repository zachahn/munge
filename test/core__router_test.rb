require "test_helper"

class CoreRouterTest < Minitest::Test
  def setup
    @router = Munge::Core::Router.new(alterant: new_dummy_alterant)
  end

  def new_item
    OpenStruct.new(route: "")
  end

  def register_dummy_router!
    @dummy_router =
      QuickDummy.new(
        type: -> { :route },
        match?: -> (_route, _itemish) { true },
        call: -> (_route, _itemish) { "dummy/route" }
      )

    @router.register(@dummy_router)
  end

  def register_dummy_index_router!
    @dummy_index_router =
      QuickDummy.new(
        type: -> { :filepath },
        match?: -> (*) { true },
        call: -> (route, _itemish) { "#{route}/index.html" }
      )

    @router.register(@dummy_index_router)
  end

  def register_dummy_rot1_router!
    @dummy_rot1_router =
      QuickDummy.new(
        type: -> { :filepath },
        match?: -> (*) { true },
        call: -> (route, _itemish) { route.tr("a-z", "b-za") }
      )

    @router.register(@dummy_rot1_router)
  end

  def register_dummy_rot13_router!
    @rot13_router =
      QuickDummy.new(
        type: -> { :route },
        match?: -> (*) { true },
        call: -> (route, *) { route.tr("a-z", "n-za-m") }
      )

    @router.register(@rot13_router)
  end

  def register_dummy_duplicate_only_route_router!
    @duplicate_router =
      QuickDummy.new(
        type: -> { :route },
        match?: -> (*) { true },
        call: -> (route, *) { route + route }
      )

    @router.register(@duplicate_router)
  end

  def new_dummy_alterant
    QuickDummy.new(transform: -> (*) { "dummy transformed text" })
  end

  def test_route_single_router
    item = new_item

    register_dummy_router!

    assert_equal "/dummy/route", @router.route(item)
  end

  def test_filepath_single_router
    item       = new_item
    item.route = "super/cool/route"

    register_dummy_index_router!

    assert_equal "super/cool/route/index.html", @router.filepath(item)
  end

  def test_route_multiple_routers
    item = new_item

    register_dummy_router!
    register_dummy_rot13_router!

    assert_equal "/qhzzl/ebhgr", @router.route(item)
  end

  def test_filepath_multiple_routers
    item       = new_item
    item.route = "super/cool/route"

    register_dummy_index_router!
    register_dummy_rot1_router!

    assert_equal "tvqfs/dppm/spvuf/joefy.iunm", @router.filepath(item)
  end

  def test_filepath_runs_route_first_then_runs_filepath
    item       = new_item
    item.route = "super/cool/route"

    # register filepath routers first
    register_dummy_index_router!
    register_dummy_rot1_router!

    # register route routers second (but these should run first)
    register_dummy_router!
    register_dummy_rot13_router!

    # Route should only be rot13
    assert_equal "/qhzzl/ebhgr", @router.route(item)

    # Filepath's dir should be rot14
    # Filepath's basename should be: rot1
    assert_equal "riaam/fcihs/joefy.iunm", @router.filepath(item)
  end
end
