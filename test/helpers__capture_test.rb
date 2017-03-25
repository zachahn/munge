require "test_helper"

class HelpersCaptureTest < TestCase
  test "capture" do
    helpers =
      QuickDummy.new(
        get_binding: -> { binding },
        capture_test: lambda do |&block|
          inner = capture(&block).upcase
          append_to_erbout(block.binding, inner)
        end
      )

    helpers.extend(Munge::Helpers::Capture)

    template =
      "<h1>hi</h1>\n" \
      "<% capture_test do %>\n" \
      "  Text\n" \
      "<% end %>"

    erb = ERB.new(template)
    output = erb.result(helpers.get_binding)

    assert_equal("<h1>hi</h1>\n\n  TEXT\n", output)
  end
end
