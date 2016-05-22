require "test_helper"

module RouterInterfaceTest
  extend Declarative

  test "#type interface" do
    router.type
  end

  test "#match? interface" do
    router.match?("/initial-route", new_text_item)
    router.match?("/initial-route", new_binary_item)
  end

  test "#call interface" do
    assert_respond_to(router, :call)
    assert_equal(2, router.method(:call).arity)
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
