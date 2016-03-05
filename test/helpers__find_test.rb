require "test_helper"

class HelpersFindTest < Minitest::Test
  def setup
    source = { id: "item" }

    @renderer = Object.new
    @renderer.instance_variable_set(:@source, source)
    @renderer.extend(Munge::Helpers::Find)
  end

  def test_find
    item = @renderer.items[:id]

    assert_equal "item", item
  end
end
