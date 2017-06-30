require "test_helper"

class ConglomerateRouterTest < TestCase
  test "route single router" do
    router = new_router
    item = new_item

    router.register(new_router_dummy)

    assert_equal("/dummy/route", router.route(item))
  end

  test "filepath single router" do
    router = new_router
    router.register(new_router_index)
    item = new_item
    item.route = "super/cool/route"

    assert_equal("super/cool/route/index.html", router.filepath(item))
  end

  test "route multiple routers" do
    router = new_router
    router.register(new_router_dummy)
    router.register(new_router_rot13)
    item = new_item

    assert_equal("/qhzzl/ebhgr", router.route(item))
  end

  test "filepath multiple routers" do
    router = new_router
    router.register(new_router_index)
    router.register(new_router_rot1)
    item = new_item
    item.route = "super/cool/route"

    assert_equal("tvqfs/dppm/spvuf/joefy.iunm", router.filepath(item))
  end

  test "filepath runs route first, then runs filepath" do
    router = new_router
    item = new_item
    item.route = "super/cool/route"

    # register filepath routers first
    router.register(new_router_index)
    router.register(new_router_rot1)

    # register route routers second (but these should run first)
    router.register(new_router_dummy)
    router.register(new_router_rot13)

    # Route should only be rot13
    assert_equal("/qhzzl/ebhgr", router.route(item))

    # Filepath's dir should be rot14
    # Filepath's basename should be: rot1
    assert_equal("riaam/fcihs/joefy.iunm", router.filepath(item))
  end

  test "registering invalid router" do
    router = new_router
    bad_router = new_router_invalid

    assert_raises do
      router.register(bad_router)
    end
  end

  test "routing item with no route" do
    router = new_router
    item = new_item
    item.route = nil

    router.register(new_router_dummy)

    assert_raises do
      router.route(item)
    end
  end

  private

  def new_item
    OpenStruct.new(route: "")
  end

  def new_router_invalid
    QuickDummy.new(
      type: -> { :invalid },
      match?: -> (*) { true },
      call: -> { "" }
    )
  end

  def new_router_dummy
    QuickDummy.new(
      type: -> { :route },
      match?: -> (_route, _itemish) { true },
      call: -> (_route, _itemish) { "dummy/route" }
    )
  end

  def new_router_index
    QuickDummy.new(
      type: -> { :filepath },
      match?: -> (*) { true },
      call: -> (route, _itemish) { "#{route}/index.html" }
    )
  end

  def new_router
    Munge::Conglomerate::Router.new(processor: new_dummy_processor)
  end

  def new_router_rot1
    QuickDummy.new(
      type: -> { :filepath },
      match?: -> (*) { true },
      call: -> (route, _itemish) { route.tr("a-z", "b-za") }
    )
  end

  def new_router_rot13
    QuickDummy.new(
      type: -> { :route },
      match?: -> (*) { true },
      call: -> (route, *) { route.tr("a-z", "n-za-m") }
    )
  end

  def new_dummy_processor
    QuickDummy.new(transform: -> (*) { "dummy transformed text" })
  end
end
