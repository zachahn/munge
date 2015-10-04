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
end
