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
