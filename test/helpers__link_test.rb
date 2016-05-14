require "test_helper"

class HelpersLinkTest < TestCase
  def setup
    dummy_router = Object.new

    def dummy_router.route(*)
      "/super/cool"
    end

    @renderer = Object.new
    @renderer.instance_variable_set(:@router, dummy_router)
    @renderer.extend(Munge::Helpers::Link)
  end

  def test_path_to
    url = @renderer.path_to(Object.new)

    assert_equal "/super/cool", url
  end

  def test_link_to_with_custom_text
    html = @renderer.link_to(Object.new, "custom text")

    assert_equal %(<a href="/super/cool">custom text</a>), html
  end

  def test_link_to_without_custom_text
    html = @renderer.link_to(Object.new)

    assert_equal %(<a href="/super/cool">/super/cool</a>), html
  end

  def test_link_to_with_html_opts
    html = @renderer.link_to(Object.new, class: "hi", "asdf" => 3)

    assert_equal %(<a href="/super/cool" class="hi" asdf="3">/super/cool</a>), html
  end
end
