require "test_helper"

class HelperFindTest < Minitest::Test
  def setup
    source = { id: "item" }

    @renderer = Object.new
    @renderer.instance_variable_set(:@source, source)
    @renderer.extend(Munge::Helper::Find)
  end

  def test_url_for
    item = @renderer.items[:id]

    assert_equal "item", item
  end
end
