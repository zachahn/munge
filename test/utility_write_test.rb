require "test_helper"

class UtilityWriteTest < Minitest::Test
  def setup
    FakeFS.activate!

    @output_dir = "/abspath/to/output"
    @file = "relpath/to/file.html"

    FileUtils.mkdir_p(@output_dir)

    @writer = Munge::Utility::Write.new(@output_dir, "index.html")
  end

  def teardown
    FakeFS.deactivate!
  end

  def test_works
    @writer.write(@file, "<3\n")

    assert_equal true, File.exist?("#{@output_dir}/#{@file}")
    assert_equal "<3\n", File.read("#{@output_dir}/#{@file}")
  end
end
