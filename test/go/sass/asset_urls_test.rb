require "test_helper"

class GoSassAssetUrlsTest < TestCase
  test "#font_url" do
    output = render(%(@font-face { font-family: 'cool'; src: font-url('cool.eot') format('embedded-opentype'); }))
    assert_equal(%(@font-face { font-family: 'cool'; src: url("routed/path/woah.eot") format("embedded-opentype"); }\n), output)
  end

  test "#font_url with ?" do
    output = render(%(@font-face { font-family: 'cool'; src: font-url('cool.eot?#iefix') format('embedded-opentype'); }))
    assert_equal(%(@font-face { font-family: 'cool'; src: url("routed/path/woah.eot?#iefix") format("embedded-opentype"); }\n), output)
  end

  test "#image_url" do
    output = render(%(div { background-image: image-url("cool.jpg") }))
    assert_equal(%(div { background-image: url("routed/path/wow.jpg"); }\n), output)
  end

  private

  def render(text)
    system =
      QuickDummy.new(
        items: -> { { "/fonts/cool.eot" => "woah.eot", "/images/cool.jpg" => "wow.jpg" } },
        router: -> { QuickDummy.new(route: -> (path) { "routed/path/#{path}" }) }
      )
    Munge::Go.set_sass_system!(system)

    Sass::Script::Functions.send(:define_method, :fonts_root) { "/fonts" }
    Sass::Script::Functions.send(:define_method, :images_root) { "/images" }

    engine = ::Sass::Engine.new(text, syntax: :scss, style: :compact)
    engine.render
  end
end
