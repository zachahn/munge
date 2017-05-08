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

  test "is enumerable" do
    fsreader = new_filesystem_reader

    assert_kind_of(Enumerable, fsreader)
    assert_kind_of(Enumerable, fsreader.each)
  end

  test "yields an item" do
    File.write(File.join(@test_directory, "index.html.erb"), "asdf")

    fsreader = new_filesystem_reader
    item = fsreader.each.to_a.first

    assert_equal("index.html.erb", item.relpath)
    assert_equal("asdf", item.content)
    assert_instance_of(FakeFS::File::Stat, item.stat)
  end

  test "doesn't yield directories" do
    FileUtils.mkdir_p(File.join(@test_directory, "/munge"))
    fsreader = new_filesystem_reader
    mapped = fsreader.map { |filehash| filehash }

    assert_equal(0, mapped.length)
  end

  private

  def new_item_factory
    Munge::System::ItemFactory.new(
      text_extensions: %w[html],
      ignore_extensions: []
    )
  end

  def new_filesystem_reader
    Munge::System::Readers::Filesystem.new(@test_directory, new_item_factory)
  end
end
