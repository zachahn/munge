require "test_helper"

class CoreConfigTest < Minitest::Test
  def test_config
    config = Munge::Core::Config.new(File.join(example_path, "config.yml"))

    assert_equal "src", config[:source]
    assert_equal "dest", config[:output]
    assert_equal nil, config["source"]
    assert_equal nil, config[:this_doesnt_exist]
  end

  def test_empty_config
    config = Munge::Core::Config.new(File.join(old_fixtures_path, "empty.yml"))

    assert_equal nil, config[:source]
  end
end
