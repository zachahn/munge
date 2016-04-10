require "test_helper"

class UtilConfigTest < TestCase
  def test_config
    config = Munge::Util::Config.read(File.join(seeds_path, "config.yml"))

    assert_equal "src", config[:source]
    assert_equal "dest", config[:output]
    assert_equal nil, config["source"]
    assert_equal nil, config[:this_doesnt_exist]
  end

  def test_invalid_config
    FakeFS do
      File.write("/config.yml", "- hi\n- bye\n")
      @config = Munge::Util::Config.read("/config.yml")
    end

    assert_instance_of Hash, @config
  end

  def test_invalid_yaml
    assert_raises do
      FakeFS do
        File.write("/config.yml", "--- `")
        Munge::Util::Config.read("/config.yml")
      end
    end
  end

  def test_empty_yaml
    FakeFS do
      File.write("/config.yml", "")
      @config = Munge::Util::Config.read("/config.yml")
    end

    assert_instance_of Hash, @config
  end

  def test_expanding_of_paths
    config = Munge::Util::Config.read(File.join("seeds", "config.yml"))

    assert_equal "src", config[:source]
  end
end
