require "test_helper"

class HelpersFindTest < TestCase
  test "#find" do
    item = new_renderer.items[:id]

    assert_equal("item", item)
  end

  private

  def new_renderer
    items = { id: "item" }

    system = Object.new
    system.define_singleton_method(:items) { items }

    renderer = tilt_scope_class.new(system, {})
    renderer.extend(Munge::Helpers::Find)

    renderer
  end
end
