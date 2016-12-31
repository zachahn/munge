require "test_helper"

class UtilConfigTest < TestCase
  test "config" do
    config = Munge::Util::Config.read(File.join(seeds_path, "config.yml"))

    assert_equal("src", config[:source])
    assert_equal("dest", config[:output])
    assert_nil(config["source"])
    assert_nil(config[:this_doesnt_exist])
  end

  test "invalid config" do
    FakeFS do
      File.write("/config.yml", "- hi\n- bye\n")
      @config = Munge::Util::Config.read("/config.yml")
    end

    assert_instance_of(Hash, @config)
  end

  test "invalid yaml" do
    assert_raises do
      FakeFS do
        File.write("/config.yml", "--- `")
        Munge::Util::Config.read("/config.yml")
      end
    end
  end

  test "empty yaml" do
    FakeFS do
      File.write("/config.yml", "")
      @config = Munge::Util::Config.read("/config.yml")
    end

    assert_instance_of(Hash, @config)
  end

  test "expanding of paths" do
    config = Munge::Util::Config.read(File.join("seeds", "config.yml"))

    assert_equal("src", config[:source])
  end
end
