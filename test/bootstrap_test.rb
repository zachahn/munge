require "test_helper"

class BootstrapTest < Minitest::Test
  def test_initialize
    bootstrap = Munge::Bootstrap.new(
      **root_and_config_args,
      **setup_args,
      **rules_args
    )

    assert_kind_of Munge::Application, bootstrap.app
  end

  def test_reading_setup
    err = assert_raises do
      FakeFS do
        FakeFS::FileSystem.clone(seeds_path)
        File.write("/fake-setup.rb", %(fail "setup fail"))

        Munge::Bootstrap.new(
          **root_and_config_args,
          **rules_args,
          setup_path: "/fake-setup.rb"
        )
      end
    end

    assert_equal "setup fail", err.message
    assert_match(%r{/fake-setup.rb}, err.backtrace[0])
  end

  def test_reading_rules
    err = assert_raises do
      FakeFS do
        FakeFS::FileSystem.clone(seeds_path)
        File.write("/fake-rules.rb", %(fail "rules fail"))

        Munge::Bootstrap.new(
          **root_and_config_args,
          **setup_args,
          rules_path: "/fake-rules.rb"
        )
      end
    end

    assert_equal("rules fail", err.message)
    assert_match(%r{/fake-rules.rb}, err.backtrace[0])
  end

  private

  def root_and_config_args
    {
      root_path: seeds_path,
      config: Munge::Util::Config.read(File.join(seeds_path, "config.yml"))
    }
  end

  def setup_args
    {
      setup_path: File.join(seeds_path, "setup.rb")
    }
  end

  def rules_args
    {
      rules_path: File.join(seeds_path, "rules.rb")
    }
  end
end
