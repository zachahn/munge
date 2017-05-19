require "test_helper"

class RouterAddDirectoryIndexTest < TestCase
  include RouterInterfaceTest

  test "only for filepath" do
    router = new_router

    assert_equal(:filepath, router.type)
  end

  test "#match? matches html" do
    router = new_router
    item = new_item_with_extensions(%w(html erb))

    assert_equal(true, router.match?("about", item))
    assert_equal(false, router.match?("about.htm", item))
  end

  test "#match? doesn't match non html" do
    router = new_router
    item = new_item_with_extensions(%w(gif erb))

    assert_equal(false, router.match?("about", item))
    assert_equal(false, router.match?("about.htm", item))
  end

  private

  def new_router
    Munge::Router::AddDirectoryIndex.new(
      extensions: %w(html htm md),
      index: "index.html"
    )
  end

  def new_item_with_extensions(extensions)
    item = OpenStruct.new
    item.extensions = extensions
    item
  end
end
