require "test_helper"

class SystemWriteTest < Minitest::Test
  def setup
    FakeFS.activate!

    @output_dir = "/#{SecureRandom.hex(10)}"

    FileUtils.mkdir_p(@output_dir)

    @writer = Munge::System::Write.new(output: @output_dir)
  end

  def teardown
    FakeFS.deactivate!
  end

  def test_creates_subdirectories_as_needed
    filepath = "relpath/to/file.html"

    @writer.write(filepath, "<3\n")

    assert_equal true, File.exist?("#{@output_dir}/#{filepath}")
    assert_equal "<3\n", File.read("#{@output_dir}/#{filepath}")
  end
end
