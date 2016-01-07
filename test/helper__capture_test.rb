require "test_helper"

class HelperCaptureTest < Minitest::Test
  def setup
    @renderer = Object.new
    @renderer.extend(Munge::Helper::Capture)

    def @renderer.capture_upcase(&block)
      text = capture(&block)
    end

    def @renderer.get_binding
      binding
    end
  end

  def test_find
    helpers =
      QuickDummy.new(
        get_binding: -> { binding },
        capture_test: -> (&block) do
          inner = capture(&block).upcase
          append_to_erbout(block.binding, inner)
        end
      )

    helpers.extend(Munge::Helper::Capture)

    template =
      "<h1>hi</h1>\n" \
      "<% capture_test do %>\n" \
      "  Text\n" \
      "<% end %>"

    erb    = ERB.new(template)
    output = erb.result(helpers.get_binding)

    assert_equal "<h1>hi</h1>\n\n  TEXT\n", output
  end
end
