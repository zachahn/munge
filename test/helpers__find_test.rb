require "test_helper"

class HelpersFindTest < TestCase
  def setup
    items = { id: "item" }

    @renderer = Object.new
    @renderer.instance_variable_set(:@items, items)
    @renderer.extend(Munge::Helpers::Find)
  end

  def test_find
    item = @renderer.items[:id]

    assert_equal "item", item
  end
end
