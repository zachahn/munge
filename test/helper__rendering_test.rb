require "test_helper"
require "ostruct"

class HelperRenderingTest < Minitest::Test
  def setup
    @renderer = Object.new
    @renderer.instance_variable_set(:@global_data, {})
    @renderer.extend(Munge::Helper::Rendering)
  end

  def test_basic_render
    item = OpenStruct.new
    item.content = %(<h1><%= "hi" %></h1>)
    item.frontmatter = {}
    item.relpath = "text.erb"

    output = @renderer.render(item)

    assert_equal "<h1>hi</h1>", output
  end

  def test_render_with_content_override
    item = OpenStruct.new
    item.content = %(<h1><%= "hi" %></h1>)
    item.frontmatter = {}
    item.relpath = "text.erb"

    output = @renderer.render(item, content_override: "test")

    assert_equal "test", output
  end

  def test_render_with_engine_override
    item = OpenStruct.new
    item.content = %(<h1><%= "hi" %></h1>)
    item.frontmatter = {}
    item.relpath = "text.erb"

    output = @renderer.render(item, engines: "test")

    assert_equal %(<h1><%= "hi" %></h1>), output
  end

  def test_layout_when_item_is_passed
    layout = OpenStruct.new
    layout.content = %(<h1><%= yield %></h1>)
    layout.frontmatter = {}
    layout.relpath = "layout.erb"
    layout.class = Munge::Item

    output = @renderer.layout(layout) { %(<%= "hi" %>) }

    assert_equal %(<h1><%= "hi" %></h1>), output
  end

  def test_layout_when_string_is_passed
    layout = OpenStruct.new
    layout.content = %(<h1><%= yield %></h1>)
    layout.frontmatter = {}
    layout.relpath = "layout.erb"
    layout.class = Munge::Item
    layout.id = "identifier"

    @renderer.instance_variable_set(:@layouts, { layout.id => layout })

    output = @renderer.layout("identifier") { %(<%= "hi" %>) }

    assert_equal %(<h1><%= "hi" %></h1>), output
  end

  def test_layout_in_render
    layout = OpenStruct.new
    layout.content = %(<h1><%= yield %></h1>)
    layout.frontmatter = {}
    layout.relpath = "layout.erb"
    layout.class = Munge::Item
    layout.id = "identifier"

    outer = OpenStruct.new
    outer.content = %(<div><%= layout("identifier") { render(@source["inner"]) } %></div>)
    outer.frontmatter = {}
    outer.relpath = "outer.erb"
    outer.id = "outer"

    inner = OpenStruct.new
    inner.content = %(<%= "hi" %>)
    inner.frontmatter = {}
    inner.relpath = "inner.erb"
    inner.id = "inner"

    @renderer.instance_variable_set(:@layouts, { layout.id => layout })
    @renderer.instance_variable_set(:@source, { inner.id => inner, outer.id => outer })

    output = @renderer.render(outer)

    assert_equal "<div><h1>hi</h1></div>", output
  end
end
