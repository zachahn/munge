require "test_helper"

class CliComandsServerTest < TestCase
  include CommandInterfaceTest

  test "#initialize" do
    command
  end

  private

  def bootloader
    Munge::Bootloader.new(root_path: seeds_path)
  end

  def command
    command_class.new(bootloader, livereload: false, host: "0.0.0.0", port: 7000)
  end

  def command_class
    Munge::Cli::Commands::Server
  end
end
