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

    item = @item_factory.read(File.join(source_path, "render.html.erb"))
    assert_equal "render", item.id

    item = @item_factory.read(File.join(source_path, "in/sub/dir.html.erb"))
    assert_equal "in/sub", item.id
  end
end
