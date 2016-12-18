require "test_helper"

class HelpersFindTest < TestCase
  def setup
    items = { id: "item" }

    system = Object.new
    system.define_singleton_method(:items) { items }

    @renderer = tilt_scope_class.new(system, {})
    @renderer.extend(Munge::Helpers::Find)
  end

  test "find" do
    item = @renderer.items[:id]

    assert_equal("item", item)
  end
end
