require "test_helper"

class SystemReaderFilesystemTest < TestCase
  def setup
    FakeFS.activate!
    @test_directory = "/#{SecureRandom.hex(10)}"
    FileUtils.mkdir_p(@test_directory)
  end

  def teardown
    FakeFS.deactivate!
  end

  def test_is_enumerable
    fsreader = new_filesystem_reader

    assert_kind_of Enumerable, fsreader
    assert_kind_of Enumerable, fsreader.each
  end

  def test_yields_itemlike_hash
    File.write(File.join(@test_directory, "index.html.erb"), "asdf")

    fsreader = new_filesystem_reader
    mapped   = fsreader.map { |filehash| filehash }

    assert_equal "index.html.erb", mapped.first[:relpath]
    assert_equal "asdf", mapped.first[:content]
    assert_instance_of FakeFS::File::Stat, mapped.first[:stat]
  end

  def test_doesnt_yield_directories
    FileUtils.mkdir_p(File.join(@test_directory, "/munge"))
    fsreader = new_filesystem_reader
    mapped   = fsreader.map { |filehash| filehash }

    assert_equal 0, mapped.length
  end

  private

  def new_filesystem_reader
    Munge::System::Readers::Filesystem.new(@test_directory)
  end
end
