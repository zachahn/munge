require "test_helper"

class HelpersAssetPathsTest < TestCase
  def setup
    @renderer = QuickDummy.new(
      items: -> { Hash.new { |_h, k| "#{k}_item" } },
      url_for: -> (root) { "url/for/#{root}" }
    )
    @renderer.extend(Munge::Helpers::AssetPaths)
  end

  def test_image_path
    @renderer.define_singleton_method(:images_root) { "img" }

    url = @renderer.image_path("basename")

    assert_equal "url/for/img/basename_item", url
  end

  def test_font_path
    @renderer.define_singleton_method(:fonts_root) { "otf" }

    url = @renderer.font_path("basename")

    assert_equal "url/for/otf/basename_item", url
  end

  def test_stylesheet_path
    @renderer.define_singleton_method(:stylesheets_root) { "css" }

    url = @renderer.stylesheet_path("basename")

    assert_equal "url/for/css/basename_item", url
  end

  def test_javascript_path
    @renderer.define_singleton_method(:javascripts_root) { "js" }

    url = @renderer.javascript_path("basename")

    assert_equal "url/for/js/basename_item", url
  end
end
