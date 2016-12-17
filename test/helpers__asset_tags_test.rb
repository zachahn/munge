require "test_helper"

class HelpersAssetTagsTest < TestCase
  def setup
    @renderer =
      QuickDummy.new(
        stylesheet_path: -> (basename) { "#{basename}.css" },
        javascript_path: -> (basename) { "#{basename}.js" },
        image_path: -> (basename) { basename },
        items: -> { Hash.new("item".freeze) },
        render: -> (_) { "rendered item" }
      )
    @renderer.extend(Munge::Helpers::AssetTags)
    @renderer.extend(Munge::Helpers::Tag)
  end

  test "#stylesheet_tag returns a tag with correct path and options" do
    tag = @renderer.stylesheet_tag("foo", class: "id")

    assert_equal %(<link class="id" rel="stylesheet" href="foo.css" />), tag
  end

  test "#javascript_tag returns a tag with correct path and options" do
    tag = @renderer.javascript_tag("foo", id: "class")

    assert_equal %(<script id="class" type="text/javascript" src="foo.js"></script>), tag
  end

  test "#stylesheet_tag has overrideable stylesheet rel and href" do
    tag = @renderer.stylesheet_tag("foo", rel: "stylesheet/less", href: "bar.less")

    assert_equal %(<link rel="stylesheet/less" href="bar.less" />), tag
  end

  test "#javascript_tag has overrideable javascript type and src" do
    tag = @renderer.javascript_tag("foo", type: "text/coffeescript", src: "bar.coffee")

    assert_equal %(<script type="text/coffeescript" src="bar.coffee"></script>), tag
  end

  test "#image_tag returns a tag with correct path and options" do
    tag = @renderer.image_tag("foo.jpg", alt: "bar")

    assert_equal(%(<img alt="bar" src="foo.jpg" />), tag)
  end

  test "#inline_stylesheet_tag returns contents of css around correct tags" do
    tag = @renderer.inline_stylesheet_tag("foo", id: "class")

    assert_equal %(<style id="class">rendered item</style>), tag
  end

  test "#inline_javascript_tag returns contents of js around correct tags" do
    tag = @renderer.inline_javascript_tag("foo", class: "id")

    assert_equal %(<script class="id">rendered item</script>), tag
  end
end
