require "test_helper"

class CoreSourceItemFactoryTest < Minitest::Test
  def setup
    binary_extensions = %w(gif png)
    ignored_basenames = %w(index dir)

    @item_factory = Munge::ItemFactory.new(source_path, binary_extensions, :fs_memory, ignored_basenames)
  end

  def test_item_read
    item = @item_factory.read(File.join(source_path, "frontmatter.html.erb"))
    assert_equal %(Guess he wants to play, a <%= song_name %>\n), item.content
    assert_equal "love game", item["song_name"]
  end

  def test_type
    txt = @item_factory.read(File.join(source_path, "frontmatter.html.erb"))
    assert_equal :text, txt.type

    bin = @item_factory.read(File.join(source_path, "transparent.gif"))
    assert_equal :binary, bin.type
    assert_equal Hash.new, bin.frontmatter
  end

  def test_id
    item = @item_factory.read(File.join(source_path, "index.html.erb"))
    assert_equal "", item.id

    item = @item_factory.read(File.join(source_path, "frontmatter.html.erb"))
    assert_equal "frontmatter", item.id

    item = @item_factory.read(File.join(source_path, "in/sub/dir.html.erb"))
    assert_equal "in/sub", item.id
  end

  def test_build_virtual_text
    item = @item_factory.build_virtual("probable/relpath.html.erb", "testing", {})

    assert_equal "probable/relpath", item.id
    assert_equal nil, item.abspath
    assert_equal "testing", item.content
    assert_equal Hash.new, item.frontmatter
    assert_equal :text, item.type
  end

  def test_build_virtual_binary
    item = @item_factory.build_virtual("probable/relpath.jpg", "testing", {}, type: :binary)

    assert_equal "probable/relpath", item.id
    assert_equal nil, item.abspath
    assert_equal "testing", item.content
    assert_equal Hash.new, item.frontmatter
    assert_equal :binary, item.type
  end
end
