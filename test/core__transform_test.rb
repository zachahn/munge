require "test_helper"

class CoreTransformTest < Minitest::Test
  def setup
    @allspark = new_core_transformer(new_source)
  end

  def test_resolver
    assert_equal Munge::Transformer::Tilt, @allspark.resolve_transformer(:Tilt)
    assert_equal Munge::Transformer::Tilt, @allspark.resolve_transformer(:tilt)
  end

  def test_incomplete_transformation
    item = new_item("frontmatter_and_markdown.html.md.erb")
    item.transform(:tilt, "erb")

    output = @allspark.call(item)

    assert_equal "**cant find** my drink or man\n", output
  end

  def test_multiple_manual_transforms
    item = new_item("frontmatter_and_markdown.html.md.erb")
    item.transform(:tilt, "erb")
    item.transform(:tilt, "md")

    output = @allspark.call(item)

    assert_equal "<p><strong>cant find</strong> my drink or man</p>\n", output
  end

  def test_auto_transformation
    item = new_item("frontmatter_and_markdown.html.md.erb")
    item.transform

    output = @allspark.call(item)

    assert_equal "<p><strong>cant find</strong> my drink or man</p>\n", output
  end
end
