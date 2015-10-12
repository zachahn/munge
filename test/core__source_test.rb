require "test_helper"

class CoreSourceTest < Minitest::Test
  def test_each_returns_enumerator
    source = new_source

    assert_kind_of(Enumerator, source.each)
  end

  def test_enumerator_is_not_empty
    source = new_source

    refute_nil(source.each.to_a)
  end

  def test_build_virtual_item
    item = new_source.build_virtual_item("foo/bar.jpg", "binary content lol", {}, type: :binary)

    assert_equal "foo/bar", item.id
    assert_equal "binary content lol", item.content
    assert_equal :binary, item.type
  end
end
