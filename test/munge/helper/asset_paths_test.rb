require "test_helper"

class HelperAssetPathsTest < TestCase
  test "#image_path" do
    renderer = new_renderer_with_method(:images_root) { "img" }

    url = renderer.image_path("basename")

    assert_equal("path/to/img/basename_item", url)
  end

  test "#font_path" do
    renderer = new_renderer_with_method(:fonts_root) { "otf" }

    url = renderer.font_path("basename")

    assert_equal("path/to/otf/basename_item", url)
  end

  test "#stylesheet_path" do
    renderer = new_renderer_with_method(:stylesheets_root) { "css" }

    url = renderer.stylesheet_path("basename")

    assert_equal("path/to/css/basename_item", url)
  end

  test "#javascript_path" do
    renderer = new_renderer_with_method(:javascripts_root) { "js" }

    url = renderer.javascript_path("basename")

    assert_equal("path/to/js/basename_item", url)
  end

  private

  def new_renderer_with_method(name, &block)
    renderer = new_renderer
    renderer.define_singleton_method(name, &block)
    renderer
  end

  def new_renderer
    renderer = QuickDummy.new(
      items: -> { Hash.new { |_h, k| "#{k}_item" } },
      path_to: -> (root) { "path/to/#{root}" }
    )
    renderer.extend(Munge::Helper::AssetPaths)
    renderer
  end
end
