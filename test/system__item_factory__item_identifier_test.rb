require "test_helper"

class SystemItemFactoryItemIdentifierTest < TestCase
  test "removes specified extensions from basename" do
    identifier = Munge::System::ItemFactory::ItemIdentifier.new(remove_extensions: dynamic_extensions)

    assert_equal("foo.bar.baz", identifier.call("foo.bar.baz.erb"))
    assert_equal("foo.erbrb", identifier.call("foo.erbrb"))
  end

  test "removes specified extensions from relpath" do
    identifier = Munge::System::ItemFactory::ItemIdentifier.new(remove_extensions: dynamic_extensions)

    assert_equal("foo/bar/foo.bar.baz", identifier.call("foo/bar/foo.bar.baz.erb"))
    assert_equal("bar/foo/foo.erbrb", identifier.call("bar/foo/foo.erbrb"))
  end

  test "removes all extensions" do
    identifier = Munge::System::ItemFactory::ItemIdentifier.new(remove_extensions: remove_all_extensions)

    assert_equal("foo", identifier.call("foo.bar.baz.erb"))
    assert_equal("bar/foo", identifier.call("bar/foo.erbrb"))
  end

  test "absolute directories get translated into relative ones" do
    identifier = Munge::System::ItemFactory::ItemIdentifier.new(remove_extensions: dynamic_extensions)

    assert_equal("foo/bar/foo.bar.baz", identifier.call("/foo/bar/foo.bar.baz.erb"))
  end

  private

  def dynamic_extensions
    %w(erb scss)
  end

  def remove_all_extensions
    %w(.+)
  end
end
