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
    output = Munge::Transformer::Tilt.call(@item, nil, {})
    assert_equal "Guess he wants to play, a love game\n", output
  end

  def test_manual_transform
    output = Munge::Transformer::Tilt.call(@item, nil, {}, "erb")
    assert_equal "Guess he wants to play, a love game\n", output
  end
end
