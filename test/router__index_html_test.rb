require "test_helper"

class RouterIndexHtmlTest < Minitest::Test
  def setup
    alterant =
      QuickDummy.new(
        transform: -> (item) { "dummy transformed text" }
      )

    @index_html =
      Munge::Router::IndexHtml.new(
        html_extensions: %w(html htm md),
        index: "index.html"
      )
  end

  def new_item(relpath, type: :text, id: nil)
    Munge::Item.new(
      type: :text,
      relpath: relpath,
      id: id || relpath.split(".").first,
      content: ""
    )
  end

  def test_match_html
    item = OpenStruct.new
    item.extensions = %w(html erb)

    assert_equal true, @index_html.match?("about", "", item)
    assert_equal false, @index_html.match?("about.htm", "", item)
  end

  def test_match_not_html
    item = OpenStruct.new
    item.extensions = %w(gif erb)

    assert_equal false, @index_html.match?("about", "", item)
    assert_equal false, @index_html.match?("about.htm", "", item)
  end

  def test_route_without_hashing_because_of_extension
    item = Object.new

    assert_equal "about/index.html", @index_html.filepath("about", "", item)
  end
end
