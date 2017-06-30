require "test_helper"

class HelperFindTest < TestCase
  test "#items" do
    item = new_renderer.items[:id]

    assert_equal("an item", item)
  end

  test "#layouts" do
    item = new_renderer.layouts[:id]

    assert_equal("a layout", item)
  end

  private

  def new_renderer
    items = { id: "an item" }
    layouts = { id: "a layout" }

    conglomerate = Object.new
    conglomerate.define_singleton_method(:items) { items }
    conglomerate.define_singleton_method(:layouts) { layouts }

    renderer = Object.new
    renderer.extend(Munge::Helper::Find)
    renderer.extend(Munge::Helper::DefineModule.new(:conglomerate, conglomerate))

    renderer
  end
end
