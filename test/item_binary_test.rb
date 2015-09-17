require "test_helper"

class ItemBinaryTest < Minitest::Test
  def setup
    fixtures = File.absolute_path(File.expand_path("../fixtures", __FILE__))

    fixture = "#{fixtures}/transparent.gif"

    @item = Munge::Item::Binary.new(
      Munge::Attribute::Path.new(fixtures, fixture),
      Munge::Attribute::Content.new(File.read(fixture)),
      Munge::Attribute::Metadata.new(fixture)
    )
  end

  def test_item_type_is_binary
    assert_equal true, @item.binary?
  end

  def test_content_and_frontmatter
    assert_equal({}, @item.frontmatter)
  end
end
