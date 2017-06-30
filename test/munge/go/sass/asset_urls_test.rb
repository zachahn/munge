require "test_helper"

class GoSassAssetUrlsTest < TestCase
  test "#font_url" do
    input = %(
      @font-face {
        font-family: 'cool';
        src: font-url('cool.eot') format('embedded-opentype');
      }
    )

    expected =
      %(@font-face { font-family: 'cool'; ) +
      %(src: url("routed/path/woah.eot") ) +
      %(format("embedded-opentype"); }\n)

    assert_equal(expected, render(input))
  end

  test "#font_url with ?" do
    input = %(
      @font-face {
        font-family: 'cool';
        src: font-url('cool.eot?#iefix') format('embedded-opentype');
      }
    )

    expected =
      %(@font-face { font-family: 'cool'; ) +
      %(src: url("routed/path/woah.eot?#iefix") ) +
      %(format("embedded-opentype"); }\n)

    assert_equal(expected, render(input))
  end

  test "#image_url" do
    input = %(
      div {
        background-image: image-url("cool.jpg")
      }
    )

    expected =
      %(div { background-image: url("routed/path/wow.jpg"); }\n)

    assert_equal(expected, render(input))
  end

  private

  def render(text)
    conglomerate =
      QuickDummy.new(
        items: -> { { "/fonts/cool.eot" => "woah.eot", "/images/cool.jpg" => "wow.jpg" } },
        router: -> { QuickDummy.new(route: -> (path) { "routed/path/#{path}" }) }
      )
    Munge::Go.set_sass_conglomerate!(conglomerate)

    Sass::Script::Functions.send(:define_method, :fonts_root) { "/fonts" }
    Sass::Script::Functions.send(:define_method, :images_root) { "/images" }

    engine = ::Sass::Engine.new(text, syntax: :scss, style: :compact)
    engine.render
  end
end
