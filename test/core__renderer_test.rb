require "test_helper"

class CoreRendererTest < Minitest::Test
  def setup
    @renderer = Munge::Core::Renderer.new
  end

  def test_render_string
    
    content = "<%= hi %>"
    data    = { hi: "hello" }
    engines = [Tilt::ERBTemplate]

    output  = @renderer.render_string(content, data: data, engines: engines)

    assert_equal "hello", output
  end

  def test_render_string_with_block
    content = "<%= yield %>"
    engines = [Tilt::ERBTemplate]

    output = @renderer.render_string(content, engines: engines) { "world" }

    assert_equal "world", output
  end
end
