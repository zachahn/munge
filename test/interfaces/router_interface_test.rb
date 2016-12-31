require "test_helper"

module RouterInterfaceTest
  extend Declarative

  test "#type interface" do
    new_router.type
  end

  test "#match? interface" do
    new_router.match?("/initial-route", new_text_item)
    new_router.match?("/initial-route", new_binary_item)
  end

  test "#call interface" do
    assert_respond_to(new_router, :call)
    parameter_types = new_router.method(:call).parameters.map(&:first)
    assert_equal(%i(req req), parameter_types)
  end

  private

  def new_text_item
    Munge::Item.new(
      type: :text,
      relpath: "index.html",
      id: "index",
      content: "content"
    )
  end

  def new_binary_item
    Munge::Item.new(
      type: :binary,
      relpath: "animated.gif",
      id: "animated.gif",
      content: "content"
    )
  end
end
