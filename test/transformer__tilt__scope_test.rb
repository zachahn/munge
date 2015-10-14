require "test_helper"

class TransformerTiltScopeTest < Minitest::Test
  def setup
    @example = File.absolute_path(File.expand_path("../example", __FILE__))
    @source  = File.join(@example, "src")
    @layouts = File.join(@example, "layouts")

    @renderer = new_tilt_scope({ title: "cool" }, new_source)
  end

  def test_render
    output = @renderer.render(new_item("about.html.md.erb"))

    assert_equal "<h1>about me</h1>\n", output
  end

  def test_layout
    inside = @renderer.render(new_item("about.html.md.erb"))
    output = @renderer.layout("req_global_data") { inside }

    assert_equal "<body>cool<h1>about me</h1>\n</body>\n", output
  end

  def test_render_in_item
    about  = new_item("about.html.md.erb")
    output = @renderer.render(new_fixture_item("render.html.erb"), data: { item: about })

    expected = "<p>testing</p>\n" \
               "<body>cool  <b>testing</b><h1>about me</h1>\n\n" \
               "</body>\n" \
               "<p>1 2 3</p>\n"

    assert_equal expected, output
  end

  def test_render_with_layout
    index = new_item("index.html.erb")
    index.layout = "req_global_data"

    output = @renderer.render_with_layout(index)
    assert_equal "<body>coolhi</body>\n", output
  end

  def test_render__specified_renderers
    output = @renderer.render(new_item("about.html.md.erb"), engines: "erb")

    assert_equal "# about me\n", output
  end

  def test_render__custom_text
    output = @renderer.render(new_item("about.html.md.erb"), content_override: "**boom <%= who %>**")

    assert_equal "<p><strong>boom me</strong></p>\n", output
  end

  def test_url_for
    item = new_item("index.html.erb")

    item.route = ""
    url        = @renderer.url_for(item)
    assert_equal "/", url

    item.route = "index.html"
    url        = @renderer.url_for(item)
    assert_equal "/index.html", url
  end

  def test_link_to
    item = new_item("index.html.erb")

    item.route = ""
    url        = @renderer.link_to(item, "home")
    assert_equal %(<a href="/">home</a>), url

    item.route = "index.html"
    url        = @renderer.link_to(item, "index page", class: "test")
    assert_equal %(<a href="/index.html" class="test">index page</a>), url
  end
end
