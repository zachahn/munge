require "test_helper"

class RouterAutoAddExtensionTest < TestCase
  include RouterInterfaceTest

  test "#match? matches gif item" do
    router = new_router
    gif_item = new_fake_item(exts: %w(gif))

    assert_equal(true, router.match?("foo", gif_item))
    assert_equal(false, router.match?("foo.gif", gif_item))
  end

  test "#match? matches txt item" do
    router = new_router
    txt_item = new_fake_item(exts: %w(txt erb))

    assert_equal(false, router.match?("foo", txt_item))
    assert_equal(false, router.match?("foo.txt", txt_item))
    assert_equal(false, router.match?("foo.gif", txt_item))
  end

  test "#call" do
    router = new_router
    gif_item = new_fake_item(exts: %w(gif))

    assert_equal("foo.gif", router.call("foo", gif_item))
    assert_equal("foo.txt.gif", router.call("foo.txt", gif_item))
  end

  private

  def new_fake_item(exts: [])
    OpenStruct.new(frontmatter: {}, extensions: exts)
  end

  def new_router
    Munge::Router::AutoAddExtension.new(keep_extensions: %w(gif))
  end
end
