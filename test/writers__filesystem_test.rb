require "test_helper"

class WritersFilesystemTest < TestCase
  def setup
    FakeFS.activate!

    @output_dir = "/#{SecureRandom.hex(10)}"

    FileUtils.mkdir_p(@output_dir)

    @writer = Munge::Writers::Filesystem.new
  end

  def teardown
    FakeFS.deactivate!
  end

  test "creates subdirectories as needed" do
    filepath = File.join(@output_dir, "relpath/to/file.html")

    @writer.write(filepath, "<3\n")

    assert_equal(true, File.exist?(filepath))
    assert_equal("<3\n", File.read(filepath))
  end
end
