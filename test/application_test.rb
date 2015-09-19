require "test_helper"

class ApplicationTest < Minitest::Test
  def setup
    example = File.expand_path("example", File.dirname(__FILE__))

    @application = Munge::Application.new("#{example}/config.yml")
  end
end
