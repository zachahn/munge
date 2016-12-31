require "test_helper"

class InitTest < TestCase
  test "#initialize" do
    bootstrap = Munge::Init.new(
      **root_and_config_args,
      **setup_args,
      **rules_args
    )

    assert_kind_of(Munge::Application, bootstrap.app)
  end

  test "reads setup" do
    err = assert_raises do
      FakeFS do
        FakeFS::FileSystem.clone(seeds_path)
        File.write("/fake-setup.rb", %(fail "setup fail"))

        Munge::Init.new(
          **root_and_config_args,
          **rules_args,
          setup_path: "/fake-setup.rb"
        )
      end
    end

    assert_equal("setup fail", err.message)
    assert_match(%r{/fake-setup.rb}, err.backtrace[0])
  end

  test "reads rules" do
    err = assert_raises do
      FakeFS do
        FakeFS::FileSystem.clone(seeds_path)
        File.write("/fake-rules.rb", %(fail "rules fail"))

        Munge::Init.new(
          **root_and_config_args,
          **setup_args,
          rules_path: "/fake-rules.rb"
        )
      end
    end

    assert_equal("rules fail", err.message)
    assert_match(%r{/fake-rules.rb}, err.backtrace[0])
  end

  test "freezes items" do
    bootstrap = Munge::Init.new(
      **root_and_config_args,
      **setup_args,
      **rules_args
    )

    assert_equal(true, bootstrap.app.items.first.frozen?)

    assert_kind_of(Munge::Application, bootstrap.app)
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
