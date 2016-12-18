require "test_helper"

class HelpersLinkTest < TestCase
  def setup
    dummy_router = Object.new

    def dummy_router.route(*)
      "/super/cool"
    end

    system = Object.new
    system.define_singleton_method(:router) { dummy_router }

    @renderer = tilt_scope_class.new(system, {})
    @renderer.extend(Munge::Helpers::Link)
    @renderer.extend(Munge::Helpers::Tag)
  end

  test "#path_to" do
    url = @renderer.path_to(Object.new)

    assert_equal("/super/cool", url)
  end

  test "#link_to with custom text" do
    html = @renderer.link_to(Object.new, "custom text")

    assert_equal(%(<a href="/super/cool">custom text</a>), html)
  end

  test "#link_to without custom text" do
    html = @renderer.link_to(Object.new)

    assert_equal(%(<a href="/super/cool">/super/cool</a>), html)
  end

  test "#link_to with html options/attributes" do
    html = @renderer.link_to(Object.new, class: "hi", "asdf" => 3)

    assert_equal(%(<a href="/super/cool" class="hi" asdf="3">/super/cool</a>), html)
  end

  test "#link_to with href option results in that option overriding default" do
    html = @renderer.link_to(Object.new, href: "/hi", class: "hi")

    assert_equal(%(<a href="/hi" class="hi">/super/cool</a>), html)
  end
end
