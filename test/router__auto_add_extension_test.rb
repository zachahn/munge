require "test_helper"

class RoutersAutoAddExtensionTest < TestCase
  def setup
    @auto_add_extension = Munge::Routers::AutoAddExtension.new(keep_extensions: %w(gif))
  end

  def test_match_gif_item
    gif_item = new_fake_item(exts: %w(gif))

    assert_equal true, @auto_add_extension.match?("foo", gif_item)
    assert_equal false, @auto_add_extension.match?("foo.gif", gif_item)
  end

  def test_match_txt_item
    txt_item = new_fake_item(exts: %w(txt erb))

    assert_equal false, @auto_add_extension.match?("foo", txt_item)
    assert_equal false, @auto_add_extension.match?("foo.txt", txt_item)
    assert_equal false, @auto_add_extension.match?("foo.gif", txt_item)
  end

  def test_call
    gif_item = new_fake_item(exts: %w(gif))

    assert_equal "foo.gif", @auto_add_extension.call("foo", gif_item)
    assert_equal "foo.txt.gif", @auto_add_extension.call("foo.txt", gif_item)
  end

  private

  def new_fake_item(exts: [])
    OpenStruct.new(frontmatter: {}, extensions: exts)
  end
end
