require "test_helper"

class RoutersRemoveIndexBasenameTest < TestCase
  include RouterInterfaceTest

  test "#match? works" do
    router = new_router

    item = OpenStruct.new
    item.extensions = %w(html erb)

    assert_equal(true, router.match?("index", item))
    assert_equal(false, router.match?("about", item))

    assert_equal(false, router.match?("index.htm", item))
    assert_equal(false, router.match?("index.html", item))
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
    Munge::Routers::RemoveIndexBasename.new(
      html_extensions: %w(html htm md),
      index: "index.html"
    )
  end
end
