require "test_helper"

class UtilPathTest < Minitest::Test
  def test_extname
    assert_equal "kl", Munge::Util::Path.extname("ab.cd/ef/gh.ij.kl")
    assert_equal "", Munge::Util::Path.extname("ab.cd/ef/gh")
    assert_equal "cd", Munge::Util::Path.extname("ab.cd")
    assert_equal "", Munge::Util::Path.extname("ab.")
  end

  def test_path_no_extension
    assert_equal "foo", Munge::Util::Path.path_no_extension("foo.rb")
    assert_equal "foo/bar", Munge::Util::Path.path_no_extension("foo/bar.rb")
    assert_equal "foo/bar", Munge::Util::Path.path_no_extension("foo/bar")
    assert_equal "foo/bar.", Munge::Util::Path.path_no_extension("foo/bar.")
  end

  def test_ensure_abspath
    assert_equal "/foo/bar.", Munge::Util::Path.ensure_abspath("foo/bar.")
    assert_equal "/foo/bar", Munge::Util::Path.ensure_abspath("/foo//bar")
  end

  def test_ensure_relpath
    assert_equal "foo/bar.", Munge::Util::Path.ensure_relpath("/foo/bar.")
    assert_equal "foo/bar", Munge::Util::Path.ensure_relpath("//foo//bar")
  end
end
