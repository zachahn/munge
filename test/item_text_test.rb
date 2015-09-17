require "test_helper"
require "tilt/erb"
require "tilt/plain"

class ItemTextTest < Minitest::Test
  def setup
    fixtures = File.absolute_path(File.expand_path("../fixtures", __FILE__))

    fixture = "#{fixtures}/subdir/file.html.erb"

    @item = Munge::Item::Text.new(
      Munge::Attribute::Path.new(fixtures, fixture),
      Munge::Attribute::Content.new(File.read(fixture)),
      Munge::Attribute::Metadata.new(fixture)
    )
  end

  def test_item_type_is_text
    assert_equal true, @item.text?
  end

  def test_content_and_frontmatter
    assert_equal %(super <%= "cool" %>\n), @item.content
    assert_equal({}, @item.frontmatter)
  end
end
