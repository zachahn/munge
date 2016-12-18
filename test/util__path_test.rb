require "test_helper"

class UtilPathTest < TestCase
  def test_dirname
    assert_equal("ab/cd", Munge::Util::Path.dirname("ab/cd/ef"))
    assert_equal("ab", Munge::Util::Path.dirname("ab/cd"))
    assert_equal("", Munge::Util::Path.dirname("ab"))
    assert_equal("", Munge::Util::Path.dirname(""))
  end

  def test_extname
    assert_equal("kl", Munge::Util::Path.extname("ab.cd/ef/gh.ij.kl"))
    assert_equal("", Munge::Util::Path.extname("ab.cd/ef/gh"))
    assert_equal("cd", Munge::Util::Path.extname("ab.cd"))
    assert_equal("", Munge::Util::Path.extname("ab."))
  end

  def test_extnames
    assert_equal(%w(ij kl), Munge::Util::Path.extnames("ab.cd/ef/gh.ij.kl"))
  end

  def test_basename
    assert_equal("foo.rb", Munge::Util::Path.basename("foo.rb"))
    assert_equal("foo.rb", Munge::Util::Path.basename("bar/foo.rb"))
  end

  def test_basename_no_extension
    assert_equal("foo", Munge::Util::Path.basename_no_extension("foo.rb"))
    assert_equal("bar", Munge::Util::Path.basename_no_extension("foo/bar.rb"))
    assert_equal("bar", Munge::Util::Path.basename_no_extension("foo/bar"))
    assert_equal("bar", Munge::Util::Path.basename_no_extension("foo/bar."))
    assert_equal("", Munge::Util::Path.basename_no_extension(""))
  end

  def test_path_no_extension
    assert_equal("foo", Munge::Util::Path.path_no_extension("foo.rb"))
    assert_equal("foo/bar", Munge::Util::Path.path_no_extension("foo/bar.rb"))
    assert_equal("foo/bar", Munge::Util::Path.path_no_extension("foo/bar"))
    assert_equal("foo/bar.", Munge::Util::Path.path_no_extension("foo/bar."))
  end

  def test_ensure_abspath
    assert_equal("/foo/bar.", Munge::Util::Path.ensure_abspath("foo/bar."))
    assert_equal("/foo/bar", Munge::Util::Path.ensure_abspath("/foo//bar"))
  end

  def test_ensure_relpath
    assert_equal("foo/bar.", Munge::Util::Path.ensure_relpath("/foo/bar."))
    assert_equal("foo/bar", Munge::Util::Path.ensure_relpath("//foo//bar"))
    assert_equal("foo/bar", Munge::Util::Path.ensure_relpath("foo//bar"))
  end

  def test_join
    assert_equal("foo/bar", Munge::Util::Path.join("foo", "", "bar"))
  end
end
