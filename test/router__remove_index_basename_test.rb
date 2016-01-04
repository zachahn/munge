require "test_helper"

class RouterRemoveIndexBasenameTest < Minitest::Test
  def setup
    @index_remover =
      Munge::Router::RemoveIndexBasename.new(
        html_extensions: %w(html htm md),
        index: "index.html"
      )
  end

  def test_match_index
    item = OpenStruct.new
    item.extensions = %w(html erb)

    assert_equal true, @index_remover.match?("index", "", item)
    assert_equal false, @index_remover.match?("about", "", item)

    assert_equal false, @index_remover.match?("index.htm", "", item)
    assert_equal false, @index_remover.match?("index.html", "", item)
    assert_equal false, @index_remover.match?("about.html", "", item)
  end

  def test_route
    item = Object.new

    assert_equal "", @index_remover.route("index", "", item)
    assert_equal "about", @index_remover.route("about/index", "", item)
  end
end
