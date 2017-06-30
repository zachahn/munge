require "test_helper"

class HelperRenderingTest < TestCase
  test "#render with basic erb input" do
    renderer = new_renderer(new_conglomerate)
    item = new_item("text.erb", %(<h1><%= "hi" %></h1>))
    output = renderer.render(item)

    assert_equal("<h1>hi</h1>", output)
  end

  test "#render with content_override" do
    renderer = new_renderer(new_conglomerate)
    item = new_item("text.erb", %(<h1><%= "hi" %></h1>))
    output = renderer.render(item, content_override: "test")

    assert_equal("test", output)
  end

  test "#render with engine override" do
    renderer = new_renderer(new_conglomerate)
    item = new_item("text.erb", %(<h1><%= "hi" %></h1>))
    output = renderer.render(item, engines: "test")

    assert_equal(%(<h1><%= "hi" %></h1>), output)
  end

  test "#render with list of engine overrides" do
    renderer = new_renderer(new_conglomerate)
    item = new_item("text.erb", %(<h1><%= "hi" %></h1>))
    output = renderer.render(item, engines: %w(html erb))

    assert_equal(%(<h1>hi</h1>), output)
  end

  test "#layout when item is passed" do
    renderer = new_renderer(new_conglomerate)
    layout = new_item("layout.erb", %(<h1><%= yield %></h1>))
    output = renderer.layout(layout) { %(<%= "hi" %>) }

    assert_equal(%(<h1><%= "hi" %></h1>), output)
  end

  test "#layout when name of layout is passed" do
    conglomerate = new_conglomerate
    renderer = new_renderer(conglomerate)

    layout = new_item("layout.erb", %(<h1><%= yield %></h1>))
    layout.id = "identifier"

    conglomerate.define_singleton_method(:layouts) { { layout.id => layout } }

    output = renderer.layout("identifier") { %(<%= "hi" %>) }

    assert_equal(%(<h1><%= "hi" %></h1>), output)
  end

  test "#layout nested in #render (#render #layout #render)" do
    conglomerate = new_conglomerate
    renderer = new_renderer(conglomerate)

    layout = new_item("layout.erb", %(<h1><%= yield %></h1>))
    layout.id = "identifier"

    outer = new_item("outer.erb", %(<div><%= layout("identifier") { render(items["inner"]) } %></div>))
    outer.id = "outer"

    inner = new_item("inner.erb", %(<%= "hi" %>))
    inner.id = "inner"

    conglomerate.define_singleton_method(:layouts) { { layout.id => layout } }
    conglomerate.define_singleton_method(:items) { { inner.id => inner, outer.id => outer } }

    output = renderer.render(outer)

    assert_equal("<div><h1>hi</h1></div>", output)
  end

  private

  def new_conglomerate
    conglomerate = Object.new
    conglomerate.define_singleton_method(:global_data) { {} }
    conglomerate.define_singleton_method(:processor) do
      if @processor.nil?
        @processor = Munge::Conglomerate::Processor.new(conglomerate)
        @processor.include(Munge::Helper::DefineModule.new(:conglomerate, conglomerate))
        @processor.register("erb", to: Tilt::ERBTemplate)
      end

      @processor
    end

    conglomerate
  end

  def new_renderer(conglomerate)
    conglomerate.processor.new_view_scope
  end

  def new_item(path, content)
    item = OpenStruct.new
    item.content = content
    item.frontmatter = {}
    item.relpath = path
    item.transforms = %i[use_extensions]
    item.class = Munge::Item
    item
  end
end
