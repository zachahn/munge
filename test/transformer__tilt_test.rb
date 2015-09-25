require "test_helper"

class TransformerTiltTest < Minitest::Test
  def setup
    @example = File.absolute_path(File.expand_path("../example", __FILE__))
    @source  = File.join(@example, "src")
    @layouts = File.join(@example, "layouts")

    @tilt_transformer = Munge::Transformer::Tilt.new(
      @source,
      @layouts,
      {}
    )
  end

  def test_auto_transform
    item   = new_item("calls_layout.html.erb")
    output = @tilt_transformer.call(item)

    assert_equal "<body><b>boom</b></body>\n", output
  end

  def test_manual_transform
    item   = new_item("frontmatter.html.erb")
    output = @tilt_transformer.call(item, nil, "erb")

    assert_equal "Guess he wants to play, a love game\n", output
  end
end
