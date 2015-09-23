require "test_helper"

class TiltItemRendererTest < Minitest::Test
  def setup
    @example = File.absolute_path(File.expand_path("../example", __FILE__))
    @source  = File.join(@example, "src")
    @layouts = File.join(@example, "layouts")

    @renderer = Munge::TiltItemRenderer.new(@layouts, title: "cool")
  end

  def new_item(item_path)
    file = "#{@source}/#{item_path}"

    Munge::Item::Text.new(
      Munge::Attribute::Path.new(@source, file),
      Munge::Attribute::Content.new(File.read(file)),
      Munge::Attribute::Metadata.new(file)
    )
  end

  def test_render
    output = @renderer.render(new_item("about.html.md.erb"))

    assert_equal "<h1>about me</h1>\n", output
  end

  def test_layout
    inside = @renderer.render(new_item("about.html.md.erb"))
    output = @renderer.layout("basic") { inside }

    assert_equal "<body>cool<h1>about me</h1>\n</body>\n", output
  end

  def test_render_in_item
    about  = new_item("about.html.md.erb")
    output = @renderer.render(new_item("render.html.erb"), item: about)

    expected = "<p>testing</p>\n" \
               "<body>cool  <b>testing</b><h1>about me</h1>\n\n" \
               "</body>\n" \
               "<p>1 2 3</p>\n"

    assert_equal expected, output
  end

  def test_render_with_layout
    index = new_item("index.html.erb")
    index.layout = "basic"

    output = @renderer.render_with_layout(index)
    assert_equal "<body>coolhi</body>\n", output
  end

  def test_render__specified_renderers
    output = @renderer.render(new_item("about.html.md.erb"), "erb")

    assert_equal "# about me\n", output
  end

  def test_render__custom_text
    output = @renderer.render(new_item("about.html.md.erb")) do
      "**boom <%= who %>**"
    end

    assert_equal "<p><strong>boom me</strong></p>\n", output
  end
end
