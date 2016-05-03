require "test_helper"

class HelpersAssetTagsTest < TestCase
  def setup
    @renderer =
      QuickDummy.new(
        stylesheet_path: -> (basename) { "#{basename}.css" },
        javascript_url: -> (basename) { "#{basename}.js" },
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

    assert_match %(<link), tag
    assert_match %(class="id"), tag
    assert_match %(rel="stylesheet" href="foo.css"), tag
    assert_match %(/>), tag
  end

  def test_javascript_tag
    tag = @renderer.javascript_tag("foo", id: "class")

    assert_match %(<script), tag
    assert_match %(id="class"), tag
    assert_match %(type="text/javascript" src="foo.js"), tag
    assert_match %(</script>), tag
  end

  def test_inline_stylesheet_tag
    tag = @renderer.inline_stylesheet_tag("foo", id: "class")

    assert_match %(<style), tag
    assert_match %(id="class"), tag
    assert_match %(>rendered item</style>), tag
  end

  def test_inline_javascript_tag
    tag = @renderer.inline_javascript_tag("foo", class: "id")

    assert_match %(<script), tag
    assert_match %(class="id"), tag
    assert_match %(>rendered item</script>), tag
  end
end
