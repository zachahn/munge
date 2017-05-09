require "test_helper"

class CliComandsViewTest < TestCase
  include CommandInterfaceTest
  include Rack::Test::Methods

  test "rack app" do
    get "/home/index.html.erb"
    assert_equal(200, last_response.status)
  end

  private

  def app
    command.instance_variable_get(:@app)
  end

  def command
    command_class.new(
      bootloader,
      host: "0.0.0.0",
      port: 3000,
      build_root: "src"
    )
  end

  def bootloader
    Munge::Bootloader.new(root_path: seeds_path)
  end

  def command_class
    Munge::Cli::Commands::View
  end
end
