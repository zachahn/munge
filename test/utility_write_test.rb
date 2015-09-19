require "test_helper"

class UtilityWriteTest < Minitest::Test
  def setup
    FakeFS.activate!

    @output_dir = "/abspath/to/output"

    FileUtils.mkdir_p(@output_dir)

    @writer = Munge::Utility::Write.new(@output_dir, "index.html")
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

  def test_write_path_directory_index
    filepath = "relpath/to/directory"

    @writer.write(filepath, "<3\n")

    assert_equal true, File.exist?("#{@output_dir}/#{filepath}/index.html")
  end
end
