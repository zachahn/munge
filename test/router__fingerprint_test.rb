require "test_helper"

class RoutersFingerprintTest < TestCase
  include RouterInterfaceTest

  test "#match? is false because frontmatter" do
    router = new_router
    item = new_fake_itemish
    item.frontmatter[:fingerprint_asset] = false

    assert_equal(false, router.match?("cool", item))
  end

  test "#match? is true because frontmatter" do
    router = new_router
    item = new_fake_itemish
    item.frontmatter[:fingerprint_asset] = true

    assert_equal(true, router.match?("cool", item))
  end

  test "#match? is true because extension" do
    router = new_router
    gif_item = new_fake_itemish
    gif_item.extensions = %w(gif)

    assert_equal(true, router.match?("cool", gif_item))
  end

  test "#match? is false because of extension" do
    router = new_router
    txt_item = new_fake_itemish
    txt_item.extensions = %w(txt)

    assert_equal(false, router.match?("cool", txt_item))
  end

  test "#call adds fingerprint before extension" do
    router = new_router
    item = new_fake_itemish

    assert_equal("transparent--#{fingerprint}.gif", router.call("transparent.gif", item))
  end

  test "#call adds fingerprint at the end if no extension" do
    router = new_router
    item = new_fake_itemish

    assert_equal("transparent--#{fingerprint}", router.call("transparent", item))
  end

  test "#call treats route, filepath, and item.route independently" do
    router = new_router
    item = new_fake_itemish
    item.route = "transparent"

    assert_equal("foo--#{fingerprint}", router.call("foo", item))
    assert_equal("bar--#{fingerprint}", router.call("bar", item))
  end

  private

  def fingerprint
    "d41d8cd98f00b204e9800998ecf8427e"
  end

  def new_fake_itemish
    OpenStruct.new(frontmatter: {}, compiled_content: "")
  end

  def new_router
    Munge::Routers::Fingerprint.new(extensions: %w(gif), separator: "--")
  end
end
