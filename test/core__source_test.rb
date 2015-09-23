require "test_helper"

class CoreSourceTest < Minitest::Test
  def setup
    @path_to_test_files = File.expand_path(File.dirname(__FILE__))
  end

  def test_each_returns_enumerator
    source = Munge::Core::Source.new(@path_to_test_files)

    assert_kind_of(Enumerator, source.each)
  end

  def test_enumerator_is_not_empty
    source = Munge::Core::Source.new(@path_to_test_files)

    refute_nil(source.each.to_a)
  end
end
