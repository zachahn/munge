require "test_helper"

class HelpersRenderingTest < TestCase
  def setup
    @system = system = Object.new
    @system.define_singleton_method(:global_data) { {} }

    @renderer = tilt_scope_class.new(system, {})
    @renderer.extend(Munge::Helpers::Rendering)
    @renderer.extend(Munge::Helpers::Find)
    @renderer.extend(Munge::Helpers::Capture)
  end

  test "#render with basic erb input" do
    item = OpenStruct.new
    item.content = %(<h1><%= "hi" %></h1>)
    item.frontmatter = {}
    item.relpath = "text.erb"

    output = @renderer.render(item)

    assert_equal("<h1>hi</h1>", output)
  end

  test "#render with content_override" do
    item = OpenStruct.new
    item.content = %(<h1><%= "hi" %></h1>)
    item.frontmatter = {}
    item.relpath = "text.erb"

    output = @renderer.render(item, content_override: "test")

    assert_equal("test", output)
  end

  test "#render with engine override" do
    item = OpenStruct.new
    item.content = %(<h1><%= "hi" %></h1>)
    item.frontmatter = {}
    item.relpath = "text.erb"

    output = @renderer.render(item, engines: "test")

    assert_equal(%(<h1><%= "hi" %></h1>), output)
  end

  test "#render with list of engine overrides" do
    item = OpenStruct.new
    item.content = %(<h1><%= "hi" %></h1>)
    item.frontmatter = {}
    item.relpath = "text.erb"

    output = @renderer.render(item, engines: %w(html erb))

    assert_equal(%(<h1>hi</h1>), output)
  end

  test "#layout when item is passed" do
    layout = OpenStruct.new
    layout.content = %(<h1><%= yield %></h1>)
    layout.frontmatter = {}
    layout.relpath = "layout.erb"
    layout.class = Munge::Item

    output = @renderer.layout(layout) { %(<%= "hi" %>) }

    assert_equal(%(<h1><%= "hi" %></h1>), output)
  end

  test "#layout when name of layout is passed" do
    layout = OpenStruct.new
    layout.content = %(<h1><%= yield %></h1>)
    layout.frontmatter = {}
    layout.relpath = "layout.erb"
    layout.class = Munge::Item
    layout.id = "identifier"

    @system.define_singleton_method(:layouts) { { layout.id => layout } }

    output = @renderer.layout("identifier") { %(<%= "hi" %>) }

    assert_equal(%(<h1><%= "hi" %></h1>), output)
  end

  test "#layout nested in #render (#render #layout #render)" do
    layout = OpenStruct.new
    layout.content = %(<h1><%= yield %></h1>)
    layout.frontmatter = {}
    layout.relpath = "layout.erb"
    layout.class = Munge::Item
    layout.id = "identifier"

    outer = OpenStruct.new
    outer.content = %(<div><%= layout("identifier") { render(items["inner"]) } %></div>)
    outer.frontmatter = {}
    outer.relpath = "outer.erb"
    outer.id = "outer"

    inner = OpenStruct.new
    inner.content = %(<%= "hi" %>)
    inner.frontmatter = {}
    inner.relpath = "inner.erb"
    inner.id = "inner"

    @system.define_singleton_method(:layouts) { { layout.id => layout } }
    @system.define_singleton_method(:items) { { inner.id => inner, outer.id => outer } }

    output = @renderer.render(outer)

    assert_equal("<div><h1>hi</h1></div>", output)
  end
end
