require "test_helper"

class ApplicationTest < Minitest::Test
  def setup
    @application = Munge::Application.new("#{example_path}/config.yml")
  end

  def test_setup
  end

  def test_new_virtual_item
    @application.new_virtual_item
  end
end
