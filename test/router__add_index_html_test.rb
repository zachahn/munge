require "test_helper"

class RouterAddIndexHtmlTest < Minitest::Test
  def setup
    @index_html =
      Munge::Router::AddIndexHtml.new(
        html_extensions: %w(html htm md),
        index: "index.html"
      )
  end

  def test_only_for_filepath
    assert_equal :filepath, @index_html.type
  end

  def test_match_html
    item = OpenStruct.new
    item.extensions = %w(html erb)

    assert_equal true, @index_html.match?("about", item)
    assert_equal false, @index_html.match?("about.htm", item)
  end

  def test_match_not_html
    item = OpenStruct.new
    item.extensions = %w(gif erb)

    assert_equal false, @index_html.match?("about", item)
    assert_equal false, @index_html.match?("about.htm", item)
  end

  def test_route_without_hashing_because_of_extension
    item = Object.new

    assert_equal "about/index.html", @index_html.call("about", item)
  end
end
