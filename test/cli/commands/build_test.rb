require "test_helper"

class CliComandsBuildTest < TestCase
  include CommandInterfaceTest

  private

  def command
    command_class.new(bootloader, dry_run: true, reporter: "Default", verbosity: "all")
  end

  def bootloader
    Munge::Bootloader.new(root_path: seeds_path)
  end

  def command_class
    Munge::Cli::Commands::Build
  end
end
