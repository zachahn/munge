require "test_helper"

class ItemFactoryTest < Minitest::Test
  def setup
    @fixtures = File.absolute_path(File.expand_path("../fixtures", __FILE__))

    binary_extensions = %w(gif png)

    @item_factory = Munge::ItemFactory.new(binary_extensions, @fixtures)
  end

  def test_item_makes_binaries
    item = @item_factory.create("#{@fixtures}/transparent.gif")

    assert_kind_of Munge::Item::Binary, item
  end

  def test_item_makes_texts
    item = @item_factory.create("#{@fixtures}/subdir/file.html.erb")

    assert_kind_of Munge::Item::Text, item
  end
end
