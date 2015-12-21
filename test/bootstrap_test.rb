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

  def test_initialize_from_fs
    bootstrap = Munge::Bootstrap.new_from_fs(
      root_path: seeds_path,
      config_path: File.join(seeds_path, "config.yml"),
      setup_path: File.join(seeds_path, "setup.rb"),
      rules_path: File.join(seeds_path, "rules.rb")
    )

    assert_kind_of Munge::Application, bootstrap.app
  end

  def test_reading_setup
    err = assert_raises {
      Munge::Bootstrap.new(
        **root_and_config_args,
        **rules_args,
        setup_string: %(fail "setup fail"),
        setup_path: "fake setup path"
      )
    }

    assert_equal "setup fail", err.message
    assert_match /fake setup path/, err.backtrace[0]
  end

  def test_reading_rules
    err = assert_raises {
      Munge::Bootstrap.new(
        **root_and_config_args,
        **setup_args,
        rules_string: %(fail "rules fail"),
        rules_path: "fake rules path"
      )
    }

    assert_equal "rules fail", err.message
    assert_match /fake rules path/, err.backtrace[0]
  end

  private

  def root_and_config_args
    {
      root_path: seeds_path,
      config: Munge::Core::Config.new(File.join(seeds_path, "config.yml"))
    }
  end

  def setup_args
    {
      setup_string: File.read(File.join(seeds_path, "setup.rb")),
      setup_path: File.join(seeds_path, "setup.rb")
    }
  end

  def rules_args
    {
      rules_string: File.read(File.join(seeds_path, "rules.rb")),
      rules_path: File.join(seeds_path, "rules.rb")
    }
  end
end
