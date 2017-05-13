require "test_helper"

class ConfigTest < TestCase
  test "#initialize prefills config" do
    config = Munge::Config.new(foo: "bar")

    assert_equal("bar", config.foo)
  end

  test "hashlike getter and setter" do
    config = Munge::Config.new
    config[:foo] = "bar"

    assert_equal("bar", config[:foo])
  end

  test "method getter and setter" do
    config = Munge::Config.new
    config.foo = "bar"

    assert_equal("bar", config.foo)
  end

  test "method getter doesn't exist" do
    config = Munge::Config.new
    config.foo = "bar"

    assert_raises(Munge::Errors::ConfigKeyNotFound) do
      config.dne
    end
  end

  test "swappable setter/getter" do
    config = Munge::Config.new
    config.foo = "bar"

    assert_equal("bar", config[:foo])
  end

  test "#[] as string" do
    config = Munge::Config.new(foo: "bar")

    assert_equal("bar", config["foo"])
  end

  test "#[] when not found" do
    config = Munge::Config.new(foo: "bar")

    assert_raises(Munge::Errors::ConfigKeyNotFound) do
      config["dne"]
    end
  end

  test "#respond_to?" do
    config = Munge::Config.new(foo: "bar")

    assert_equal(true, config.respond_to?("foo"))
    assert_equal(false, config.respond_to?("lol"))
    assert_equal(true, config.respond_to?("hihi="))
  end
end
