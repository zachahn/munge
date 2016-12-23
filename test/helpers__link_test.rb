require "test_helper"

class HelpersLinkTest < TestCase
  def setup
    dummy_router = Object.new
    dummy_router.define_singleton_method(:route) do |obj|
      if obj.respond_to?(:route)
        "/object/#{obj.route}"
      else
        "/string/#{obj}"
      end
    end

    system = Object.new
    system.define_singleton_method(:router) { dummy_router }
    system.define_singleton_method(:items) { Hash.new { |_hash, key| key } }

    @renderer = tilt_scope_class.new(system, {})
    @renderer.extend(Munge::Helpers::Link)
    @renderer.extend(Munge::Helpers::Tag)
  end

  test "#path_to" do
    url = @renderer.path_to(OpenStruct.new(route: "cool"))

    assert_equal("/object/cool", url)
  end

  test "#path_to works when a string is passed in" do
    url = @renderer.path_to("cool")

    assert_equal("/string/cool", url)
  end

  test "#link_to with custom text" do
    html = @renderer.link_to(OpenStruct.new(route: "cool"), "custom text")

    assert_equal(%(<a href="/object/cool">custom text</a>), html)
  end

  test "#link_to without custom text" do
    html = @renderer.link_to(OpenStruct.new(route: "cool"))

    assert_equal(%(<a href="/object/cool">/object/cool</a>), html)
  end

  test "#link_to with html options/attributes" do
    html = @renderer.link_to(OpenStruct.new(route: "cool"), class: "hi", "asdf" => 3)

    assert_equal(%(<a href="/object/cool" class="hi" asdf="3">/object/cool</a>), html)
  end

  test "#link_to with href option results in that option overriding default" do
    html = @renderer.link_to(OpenStruct.new(route: "cool"), href: "/hi", class: "hi")

    assert_equal(%(<a href="/hi" class="hi">/object/cool</a>), html)
  end
end
