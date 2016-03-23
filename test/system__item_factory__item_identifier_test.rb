require "test_helper"

class SystemItemFactoryItemIdentifierTest < Minitest::Test
  def test_basename
    identifier = Munge::System::ItemFactory::ItemIdentifier.new(remove_extensions: dynamic_extensions)

    assert_equal "foo.bar.baz", identifier.call("foo.bar.baz.erb")
    assert_equal "foo.erbrb", identifier.call("foo.erbrb")
  end

  def test_relpath
    identifier = Munge::System::ItemFactory::ItemIdentifier.new(remove_extensions: dynamic_extensions)

    assert_equal "foo/bar/foo.bar.baz", identifier.call("foo/bar/foo.bar.baz.erb")
    assert_equal "bar/foo/foo.erbrb", identifier.call("bar/foo/foo.erbrb")
  end

  def test_remove_all
    identifier = Munge::System::ItemFactory::ItemIdentifier.new(remove_extensions: remove_all_extensions)

    assert_equal "foo", identifier.call("foo.bar.baz.erb")
    assert_equal "bar/foo", identifier.call("bar/foo.erbrb")
  end

  private

  def dynamic_extensions
    %w(erb scss)
  end

  def remove_all_extensions
    %w(.+)
  end
end
