require "test_helper"

class CoreWriteTest < Minitest::Test
  def setup
    FakeFS.activate!

    @output_dir = "/abspath/to/output"

    FileUtils.mkdir_p(@output_dir)

    @writer = Munge::Core::Write.new(@output_dir, "index.html")
  end

  def teardown
    FakeFS.deactivate!
  end

  def test_works
    filepath = "relpath/to/file.html"

    @writer.write(filepath, "<3\n")

    assert_equal true, File.exist?("#{@output_dir}/#{filepath}")
    assert_equal "<3\n", File.read("#{@output_dir}/#{filepath}")
  end
end
