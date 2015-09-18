require "test_helper"

class UtilityTransformTest < Minitest::Test
  def setup
    fixtures = File.absolute_path(File.expand_path("../fixtures", __FILE__))
    file     = "#{fixtures}/multiple_transforms.html.md.erb"

    @item = Munge::Item::Base.new(
      Munge::Attribute::Path.new(fixtures, file),
      Munge::Attribute::Content.new(File.read(file)),
      Munge::Attribute::Metadata.new(file)
    )

    @allspark = Munge::Utility::Transform.new(nil, global: "data")
  end

  def test_resolver
    assert_equal Munge::Transformer::Tilt, @allspark.resolve_transformer(:Tilt)
    assert_equal Munge::Transformer::Tilt, @allspark.resolve_transformer(:tilt)
  end

  def test_incomplete_transformation
    @item.transform(:tilt, "erb")

    output = @allspark.call(@item)

    assert_equal "**cant find** my drink or man\n", output
  end

  def test_multiple_manual_transforms
    @item.transform(:tilt, "erb")
    @item.transform(:tilt, "md")

    output = @allspark.call(@item)

    assert_equal "<p><strong>cant find</strong> my drink or man</p>\n", output
  end

  def test_auto_transformation
    @item.transform

    output = @allspark.call(@item)

    assert_equal "<p><strong>cant find</strong> my drink or man</p>\n", output
  end
end
