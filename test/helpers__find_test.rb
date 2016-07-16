require "test_helper"

class HelpersFindTest < TestCase
  def setup
    items = { id: "item" }

    system = Object.new
    system.define_singleton_method(:items) { items }

    @renderer = Object.new
    @renderer.define_singleton_method(:system) { system }
    @renderer.extend(Munge::Helpers::Find)
  end

  test "find" do
    item = @renderer.items[:id]

    assert_equal "item", item
  end
end
