require "test_helper"

class ReaderFilesystemTest < Minitest::Test
  def self.test_order
    :alpha
  end

  def setup
    @fsreader = Munge::Reader::Filesystem.new("/")
  end

  def test_is_enumerable
    assert_kind_of Enumerable, @fsreader
    assert_kind_of Enumerable, @fsreader.each
  end

  def test_yields_itemlike_hash
    mapped = 
      FakeFS do
        File.write("/index.html.erb", "asdf")

        @fsreader.map { |filehash| filehash }
      end

    assert_equal "index.html.erb", mapped.first[:relpath]
    assert_equal "asdf", mapped.first[:content]
    assert_instance_of FakeFS::File::Stat, mapped.first[:stat]
  end

  def test_doesnt_yield_directories
    mapped = 
      FakeFS do
        FileUtils.mkdir_p("/munge")

        @fsreader.map { |filehash| filehash }
      end

    assert_equal 0, mapped.length
  end
end
