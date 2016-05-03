require "test_helper"

class HelpersAssetTagsTest < TestCase
  def setup
    @renderer =
      QuickDummy.new(
        stylesheet_path: -> (basename) { "#{basename}.css" },
        javascript_path: -> (basename) { "#{basename}.js" },
        stylesheets_root: -> { "stylesheets" },
        javascripts_root: -> { "javascripts" },
        items: -> { Hash.new("item".freeze) },
        render: -> (_) { "rendered item" }
      )
    @renderer.extend(Munge::Helpers::AssetTags)
    @renderer.extend(Munge::Helpers::Tag)
  end

  def test_stylesheet_tag
    tag = @renderer.stylesheet_tag("foo", class: "id")

    assert_match %(<link class="id" rel="stylesheet" href="foo.css" />), tag
  end

  def test_javascript_tag
    tag = @renderer.javascript_tag("foo", id: "class")

    assert_match %(<script id="class" type="text/javascript" src="foo.js"></script>), tag
  end

  def test_inline_stylesheet_tag
    tag = @renderer.inline_stylesheet_tag("foo", id: "class")

    assert_match %(<style id="class">rendered item</style>), tag
  end

  def test_inline_javascript_tag
    tag = @renderer.inline_javascript_tag("foo", class: "id")

    assert_match %(<script class="id">rendered item</script>), tag
  end
end
