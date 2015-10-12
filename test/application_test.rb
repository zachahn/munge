require "test_helper"

class ApplicationTest < Minitest::Test
  def setup
    @application = Munge::Application.new("#{example_path}/config.yml")
  end

  def test_create
    count = @application.source.count
    
    @application.create("foo/bar.html", "x", {}, type: :binary)
    
    new_count = @application.source.count

    assert_equal count + 1, new_count
  end
end
