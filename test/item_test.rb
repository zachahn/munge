require "test_helper"

class ItemTest < Minitest::Test
  def setup
    relative_fixtures_dir = File.expand_path("../fixtures", __FILE__)
    @fixtures_dir = File.absolute_path(relative_fixtures_dir)
  end

  def test_item_interface
    item = Munge::Item.create(
      @fixtures_dir,
      File.join(@fixtures_dir, "test-item-interface.html.md.erb")
    )
    # item.route = "/#{item.path.relative}"
    # item.layout = ""
    # item.apply(:erb)
    # item.write
  end
end
