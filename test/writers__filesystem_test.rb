require "test_helper"

class WritersFilesystemTest < Minitest::Test
  def setup
    FakeFS.activate!

    @output_dir = "/#{SecureRandom.hex(10)}"

    FileUtils.mkdir_p(@output_dir)

    @writer = Munge::Writers::Filesystem.new
  end

  def teardown
    FakeFS.deactivate!
  end

  def test_creates_subdirectories_as_needed
    filepath = File.join(@output_dir, "relpath/to/file.html")

    @writer.write(filepath, "<3\n")

    assert_equal true, File.exist?(filepath)
    assert_equal "<3\n", File.read(filepath)
  end
end
