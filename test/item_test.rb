require "test_helper"
require "tilt/erubis"
require "tilt/plain"

class ItemTest < Minitest::Test
  def setup
    relative_fixtures_dir = File.expand_path("../fixtures", __FILE__)
    @fixtures_dir = File.absolute_path(relative_fixtures_dir)
  end

  def test_item_interface
    item = Munge::Item.create(
      @fixtures_dir,
      File.join(@fixtures_dir, "test-item-interface.html.erb")
    )
    item.route = "/#{item.path.relative}"

    expected = "Guess he wants to play, wants to play<br>
A love game, a love game
"

    assert_equal expected, item.rendered_content
  end
end
