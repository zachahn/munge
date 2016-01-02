require "test_helper"

class CoreConfigTest < Minitest::Test
  def old_fixtures_path
    File.absolute_path(File.expand_path("../fixtures", __FILE__))
  end

  def test_config
    config = Munge::Core::Config.read(File.join(example_path, "config.yml"))

    assert_equal "src", config[:source]
    assert_equal "dest", config[:output]
    assert_equal nil, config["source"]
    assert_equal nil, config[:this_doesnt_exist]
  end

  def test_empty_config
    config = Munge::Core::Config.read(File.join(old_fixtures_path, "empty.yml"))

    assert_equal nil, config[:source]
  end

  def test_expanding_of_paths
    config = Munge::Core::Config.read(File.join("test", "example", "config.yml"))

    assert_equal "src", config[:source]
  end
end
