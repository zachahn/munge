require "test_helper"

class RouterFingerprintTest < Minitest::Test
  def setup
    @fingerprint = Munge::Router::Fingerprint.new(extensions: %w(gif))
  end

  def new_fake_item
    OpenStruct.new(frontmatter: {})
  end

  def test_match_false_because_frontmatter
    item = new_fake_item
    item.frontmatter[:fingerprint_asset] = false

    assert_equal false, @fingerprint.match?("cool", "", item)
  end

  def test_match_true_because_frontmatter
    item = new_fake_item
    item.frontmatter[:fingerprint_asset] = true

    assert_equal true, @fingerprint.match?("cool", "", item)
  end

  def test_match_because_extension
    gif_item = new_fake_item
    gif_item.extensions = %w(gif)

    assert_equal true, @fingerprint.match?("cool", "", gif_item)
  end

  def test_match_false_because_extension
    txt_item = new_fake_item
    txt_item.extensions = %w(txt)

    assert_equal false, @fingerprint.match?("cool", "", txt_item)
  end

  def test_fingerprinted_route_and_filepath
    item = new_fake_item

    assert_equal "transparent--#{fingerprint}.gif", @fingerprint.route("transparent.gif", "", item)
    assert_equal "transparent--#{fingerprint}.gif", @fingerprint.filepath("transparent.gif", "", item)
  end

  def test_fingerprinted_route_and_filepath_with_no_extension
    item = new_fake_item

    assert_equal "transparent--#{fingerprint}", @fingerprint.route("transparent", "", item)
    assert_equal "transparent--#{fingerprint}", @fingerprint.filepath("transparent", "", item)
  end

  def test_independence_of_route_and_filepath_and_itemroute
    item = new_fake_item
    item.route = "transparent"

    assert_equal "foo--#{fingerprint}", @fingerprint.route("foo", "", item)
    assert_equal "bar--#{fingerprint}.gif", @fingerprint.filepath("bar.gif", "", item)
  end

  private

  def fingerprint
    "d41d8cd98f00b204e9800998ecf8427e"
  end
end
