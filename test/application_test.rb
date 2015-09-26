require "test_helper"

class ApplicationTest < Minitest::Test
  def setup
    @application = Munge::Application.new("#{example_path}/config.yml")
  end

  def test_setup
  end
end
