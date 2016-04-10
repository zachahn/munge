require "test_helper"

class HelpersTagTest < TestCase
  def setup
    @renderer = Object.new
    @renderer.extend(Munge::Helpers::Tag)
    @renderer.extend(Munge::Helpers::Capture)
  end

  def test_empty_tag_empty
    tag = @renderer.empty_tag(:foo)

    assert_equal %(<foo />), tag
  end

  def test_empty_tag
    tag = @renderer.empty_tag(:foo, "a-b" => "cd", ef: "gh", "ijk" => "lm")

    assert_equal %(<foo a-b="cd" ef="gh" ijk="lm" />), tag
  end

  def test_contest_tag_arg
    tag = @renderer.content_tag(:bar, "test", ab: "cd")

    assert_equal %(<bar ab="cd">test</bar>), tag
  end

  def test_contest_tag_block
    tag = @renderer.content_tag(:bar, ab: "cd") { "test" }

    assert_equal %(<bar ab="cd">test</bar>), tag
  end

  def test_content_tag_empty
    tag = @renderer.content_tag(:bar, ab: "cd")

    assert_equal %(<bar ab="cd"></bar>), tag
  end
end
