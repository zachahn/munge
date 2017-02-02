require "test_helper"

class HelpersRenderingTest < TestCase
  test "#render with basic erb input" do
    renderer = new_renderer(new_system)
    item = new_item("text.erb", %(<h1><%= "hi" %></h1>))
    output = renderer.render(item)

    assert_equal("<h1>hi</h1>", output)
  end

  test "#render with content_override" do
    renderer = new_renderer(new_system)
    item = new_item("text.erb", %(<h1><%= "hi" %></h1>))
    output = renderer.render(item, content_override: "test")

    assert_equal("test", output)
  end

  test "#render with engine override" do
    renderer = new_renderer(new_system)
    item = new_item("text.erb", %(<h1><%= "hi" %></h1>))
    output = renderer.render(item, engines: "test")

    assert_equal(%(<h1><%= "hi" %></h1>), output)
  end

  test "#render with list of engine overrides" do
    renderer = new_renderer(new_system)
    item = new_item("text.erb", %(<h1><%= "hi" %></h1>))
    output = renderer.render(item, engines: %w(html erb))

    assert_equal(%(<h1>hi</h1>), output)
  end

  test "#layout when item is passed" do
    renderer = new_renderer(new_system)
    layout = new_item("layout.erb", %(<h1><%= yield %></h1>))
    output = renderer.layout(layout) { %(<%= "hi" %>) }

    assert_equal(%(<h1><%= "hi" %></h1>), output)
  end

  test "#layout when name of layout is passed" do
    system = new_system
    renderer = new_renderer(system)

    layout = new_item("layout.erb", %(<h1><%= yield %></h1>))
    layout.id = "identifier"

    system.define_singleton_method(:layouts) { { layout.id => layout } }

    output = renderer.layout("identifier") { %(<%= "hi" %>) }

    assert_equal(%(<h1><%= "hi" %></h1>), output)
  end

  test "#layout nested in #render (#render #layout #render)" do
    system = new_system
    renderer = new_renderer(system)

    layout = new_item("layout.erb", %(<h1><%= yield %></h1>))
    layout.id = "identifier"

    outer = new_item("outer.erb", %(<div><%= layout("identifier") { render(items["inner"]) } %></div>))
    outer.id = "outer"

    inner = new_item("inner.erb", %(<%= "hi" %>))
    inner.id = "inner"

    system.define_singleton_method(:layouts) { { layout.id => layout } }
    system.define_singleton_method(:items) { { inner.id => inner, outer.id => outer } }

    output = renderer.render(outer)

    assert_equal("<div><h1>hi</h1></div>", output)
  end

  private

  def new_system
    inspector = noop_inspector
    system = Object.new
    system.define_singleton_method(:global_data) { {} }
    system.define_singleton_method(:inspector) { inspector }
    system
  end

  def new_renderer(system)
    renderer = tilt_scope_class.new(system, {})
    renderer.extend(Munge::Helpers::Rendering)
    renderer.extend(Munge::Helpers::Find)
    renderer.extend(Munge::Helpers::Capture)
    renderer
  end

  def new_item(path, content)
    item = OpenStruct.new
    item.content = content
    item.frontmatter = {}
    item.relpath = path
    item.class = Munge::Item
    item
  end
end
