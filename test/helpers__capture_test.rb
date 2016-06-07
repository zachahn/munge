require "test_helper"

class HelpersCaptureTest < TestCase
  test "#append_to_erbout" do
    helpers = erb_context

    helpers.define_singleton_method(:capture_test) do |&block|
      inner = capture(&block).upcase
      append_to_erbout(block.binding, inner)
    end

    template = extract_data("append capture")

    erb    = ERB.new(template)
    output = erb.result(helpers.get_binding)

    assert_equal("<h1>hi</h1>\n\n  TEXT\n\n", output)
  end

  test "#capture" do
    template = extract_data("no output")

    erb    = ERB.new(template)
    output = erb.result(erb_context.get_binding)

    assert_match("cause you're hot", output)
    refute_match("and you're cold", output)
  end

  test "#yield_content with default and no replacement" do
    template = extract_data("yield_content block layout")
    erb      = ERB.new(template)
    output   = erb.result(erb_context.get_binding)

    assert_match("Default yield_content", output)
  end

  test "#yield_content with default and no block and no replacement" do
    template = extract_data("yield_content nonblock layout")
    erb      = ERB.new(template)
    output   = erb.result(erb_context.get_binding)

    assert_match(/^\s*$/, output)
  end

  test "#yield_content with a replacement" do
    template = extract_data("content_for yield_content")
    erb      = ERB.new(template)
    output   = erb.result(erb_context.get_binding)

    assert_match(/^\s*a\s*123\s*c\s*$/, output)
  end

  test "#yield_content with no block and with replacement" do
    template = extract_data("content_for blank yield_content")
    erb      = ERB.new(template)
    output   = erb.result(erb_context.get_binding)

    assert_match(/^\s*a\s*123\s*c\s*$/, output)
  end

  private

  def erb_context
    helpers =
      QuickDummy.new(
        get_binding: -> { binding },
      )

    helpers.extend(Munge::Helpers::Capture)

    helpers
  end
end

__END__

@@ no output

cause you're hot

<% capture do %>
  and you're cold
<% end %>


@@ append capture

<h1>hi</h1>
<% capture_test do %>
  Text
<% end %>

@@ yield_content block layout

<% yield_content :test do %>
Default yield_content
<% end %>

@@ yield_content nonblock layout

<% yield_content :test %>

@@ content_for yield_content

<% content_for :test do %>
123
<% end %>

a
<% yield_content :test do %>
b
<% end %>
c

@@ content_for blank yield_content

<% content_for :test do %>
123
<% end %>

a
<%= yield_content :test %>
c
