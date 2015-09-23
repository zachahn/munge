require "test_helper"

class CoreTransformTest < Minitest::Test
  def setup
    @example = File.absolute_path(File.expand_path("../example", __FILE__))
    @source  = File.join(@example, "src")
    @layouts = File.join(@example, "layouts")

    @allspark = Munge::Core::Transform.new(
      @source,
      @layouts,
      global: "data"
    )
  end

  def new_item(item_path)
    file = "#{@source}/#{item_path}"

    Munge::Item::Text.new(
      Munge::Attribute::Path.new(@source, file),
      Munge::Attribute::Content.new(File.read(file)),
      Munge::Attribute::Metadata.new(file)
    )
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
