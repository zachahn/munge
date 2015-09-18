require "test_helper"

class TransformerTiltTest < Minitest::Test
  def setup
    fixtures = File.absolute_path(File.expand_path("../fixtures", __FILE__))
    file     = "#{fixtures}/test-item-interface.html.erb"

    @item = Munge::Item::Base.new(
      Munge::Attribute::Path.new(fixtures, file),
      Munge::Attribute::Content.new(File.read(file)),
      Munge::Attribute::Metadata.new(file)
    )
  end

  def test_auto_transform
    output = Munge::Transformer::Tilt.call(@item, @item.content, nil, {})
    assert_equal "Guess he wants to play, a love game\n", output
  end

  def test_manual_transform
    t = Munge::Transformer::Tilt.new(@item, nil)
    output = t.call(@item.content, "erb")

    assert_equal "Guess he wants to play, a love game\n", output
  end
end
