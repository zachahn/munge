require "test_helper"

class LivereloadTest < TestCase
  test "#livereload_script has correct output" do
    output = new_renderer.livereload_script(force: true)

    expected =
      %{<script>document.write('<script src="http://' + } +
      %{(location.host || 'localhost').split(':')[0] + } +
      %{':35729/livereload.js?snipver=1"></' + 'script>')</script>}

    assert_equal(expected, output)
  end

  private

  def new_renderer
    renderer = Object.new
    renderer.extend(Munge::Helpers::Tag)
    renderer.extend(Munge::Helpers::Livereload)
    renderer
  end
end
