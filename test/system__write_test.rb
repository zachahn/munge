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

  def test_works
    filepath = "relpath/to/file.html"

    @writer.write(filepath, "<3\n")

    assert_equal true, File.exist?("#{@output_dir}/#{filepath}")
    assert_equal "<3\n", File.read("#{@output_dir}/#{filepath}")
  end

  def test_write_statuses
    filepath = "file.txt"

    status_1 = @writer.write(filepath, "<3\n")
    status_2 = @writer.write(filepath, "<3\n")
    status_3 = @writer.write(filepath, "<4\n")

    assert_equal true, status_1
    assert_equal false, status_2
    assert_equal true, status_3

    assert_equal true, File.exist?("#{@output_dir}/#{filepath}")
    assert_equal "<4\n", File.read("#{@output_dir}/#{filepath}")
  end
end
