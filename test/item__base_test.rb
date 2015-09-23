require "test_helper"

class ItemBaseTest < Minitest::Test
  def setup
    fixtures = File.absolute_path(File.expand_path("../fixtures", __FILE__))

    top_fixture = "#{fixtures}/test-item-interface.html.erb"
    sub_fixture = "#{fixtures}/subdir/file.html.erb"

    @top_item = Munge::Item::Base.new(
      Munge::Attribute::Path.new(fixtures, top_fixture),
      Munge::Attribute::Content.new(File.read(top_fixture)),
      Munge::Attribute::Metadata.new(top_fixture)
    )

    @sub_item = Munge::Item::Base.new(
      Munge::Attribute::Path.new(fixtures, sub_fixture),
      Munge::Attribute::Content.new(File.read(sub_fixture)),
      Munge::Attribute::Metadata.new(sub_fixture)
    )
  end

  def test_item_type_is_base
    assert_equal false, @top_item.virtual?
    assert_equal false, @top_item.binary?
    assert_equal false, @top_item.text?
  end

  def test_paths
    assert_equal "subdir/file.html.erb", @sub_item.relpath
    assert_equal "subdir", @sub_item.dirname
    assert_equal "file.html.erb", @sub_item.filename
    assert_equal "file", @sub_item.basename
    assert_equal "subdir/file", @sub_item.id

    assert_equal "test-item-interface.html.erb", @top_item.relpath
    assert_equal "test-item-interface.html.erb", @top_item.filename
    assert_equal "test-item-interface", @top_item.basename
    assert_equal "", @top_item.dirname
    assert_equal "test-item-interface", @top_item.id
  end

  def test_content_and_frontmatter
    assert_equal %(super <%= "cool" %>\n), @sub_item.content
    assert_equal({}, @sub_item.frontmatter)

    assert_equal "love game", @top_item.frontmatter["song_name"]
  end

  def test_stat
    assert_kind_of File::Stat, @top_item.stat
  end
end
