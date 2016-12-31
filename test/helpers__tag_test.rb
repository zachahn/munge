require "test_helper"

class HelpersTagTest < TestCase
  test "#empty_tag returns an empty tag" do
    tag = new_renderer.empty_tag(:foo)

    assert_equal(%(<foo />), tag)
  end

  test "#empty_tag has attributes" do
    tag = new_renderer.empty_tag(:foo, "a-b" => "cd", ef: "gh", "ijk" => "lm")

    assert_equal(%(<foo a-b="cd" ef="gh" ijk="lm" />), tag)
  end

  test "#content_tag content works from parameter" do
    tag = new_renderer.content_tag(:bar, "test", ab: "cd")

    assert_equal(%(<bar ab="cd">test</bar>), tag)
  end

  test "#content_tag content works from block" do
    tag = new_renderer.content_tag(:bar, ab: "cd") { "test" }

    assert_equal(%(<bar ab="cd">test</bar>), tag)
  end

  test "#content_tag doesn't need content" do
    tag = new_renderer.content_tag(:bar, ab: "cd")

    assert_equal(%(<bar ab="cd"></bar>), tag)
  end

  test "#h escapes HTML" do
    escaped_html = new_renderer.h(%(<"&>))

    assert_equal(%(&lt;&quot;&amp;&gt;), escaped_html)
  end

  test "#empty_tag can handle dangerous characters as HTML attributes" do
    escaped_html = new_renderer.empty_tag(:foo, data: %("hi"))

    assert_equal(%(<foo data="&quot;hi&quot;" />), escaped_html)
  end

  private

  def new_renderer
    renderer = Object.new
    renderer.extend(Munge::Helpers::Tag)
    renderer.extend(Munge::Helpers::Capture)
    renderer
  end
end
