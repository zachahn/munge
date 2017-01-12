require "test_helper"

class RoutersRemoveBasenameTest < TestCase
  include RouterInterfaceTest

  test "#match? items without route without extensions" do
    router = new_router

    item = OpenStruct.new
    item.extensions = %w(html erb)

    assert_equal(true, router.match?("index", item))
    assert_equal(false, router.match?("about", item))
  end

  test "#match items with explicit route extension" do
    router = new_router

    item = OpenStruct.new
    item.extensions = %w(html erb)

    assert_equal(false, router.match?("index.htm", item))
    assert_equal(false, router.match?("index.html", item))
    assert_equal(false, router.match?("about.html", item))
  end

  test "lol" do
    router =
      Munge::Routers::RemoveBasename.new(
        extensions: %w(html htm md),
        basenames: %w(index),
        keep_explicit: false
      )

    item = OpenStruct.new
    item.extensions = %w(html erb)

    assert_equal(true, router.match?("index.htm", item))
    assert_equal(true, router.match?("index.html", item))
    assert_equal(false, router.match?("about.html", item))
  end

  test "#call works" do
    router = new_router

    item = Object.new

    assert_equal("", router.call("index", item))
    assert_equal("about", router.call("about/index", item))
  end

  private

  def new_router
    Munge::Routers::RemoveBasename.new(
      extensions: %w(html htm md),
      basenames: %w(index),
      keep_explicit: true
    )
  end
end
