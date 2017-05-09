require "test_helper"

class IoDryRunTest < TestCase
  test "#write doesn't call driver#write" do
    driver = QuickDummy.new(write: -> (_path, _content) { raise "shouldn't be called" })

    io = Munge::Io::DryRun.new(driver)
    io.write("some/path", "some content\n")
  end

  test "#exist? delegates to the driver" do
    driver = Minitest::Mock.new
    driver.expect(:exist?, true, ["some/path"])

    io = Munge::Io::DryRun.new(driver)
    io.exist?("some/path")

    driver.verify
  end

  test "#read delegates to the driver" do
    driver = Minitest::Mock.new
    driver.expect(:read, "the contents\n", ["some/path"])

    io = Munge::Io::DryRun.new(driver)
    io.read("some/path")

    driver.verify
  end
end
