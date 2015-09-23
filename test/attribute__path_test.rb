require "test_helper"

class AttributePathTest < Minitest::Test
  def setup
    sources = "/absolute/path"
    file = "/absolute/path/to/file.html.css.coffee.erb"

    @path = Munge::Attribute::Path.new(sources, file)
  end

  def test_relative_path_is_correct
    assert_equal "to/file.html.css.coffee.erb", @path.relative
  end

  def test_absolute_path_is_correct
    assert_equal "/absolute/path/to/file.html.css.coffee.erb", @path.absolute
  end

  def test_basename_is_correct
    assert_equal "file", @path.basename
  end

  def test_extensions_is_correct
    assert_includes @path.extnames, "html"
    assert_includes @path.extnames, "css"
    assert_includes @path.extnames, "coffee"
    assert_includes @path.extnames, "erb"
  end
end
