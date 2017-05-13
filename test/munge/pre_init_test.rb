require "test_helper"

class PreInitTest < TestCase
  test "initializes without errors when given a path" do
    Munge::PreInit.new(seed_config_path)
  end

  test "initializes with error when config file doesn't exist" do
    assert_raises(Munge::Errors::ConfigRbNotFound) do
      Munge::PreInit.new(File.join(seeds_path, "path.dne"))
    end
  end

  test "#config returns a config" do
    preinit = Munge::PreInit.new(seed_config_path)
    config = preinit.config

    assert_kind_of(Munge::Config, config)
  end

  private

  def seed_config_path
    File.join(seeds_path, "config.rb")
  end
end
