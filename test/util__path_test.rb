require "test_helper"

class UtilPathTest < TestCase
  test ".dirname" do
    assert_equal("ab/cd", Munge::Util::Path.dirname("ab/cd/ef"))
    assert_equal("ab", Munge::Util::Path.dirname("ab/cd"))
    assert_equal("", Munge::Util::Path.dirname("ab"))
    assert_equal("", Munge::Util::Path.dirname(""))
  end

  test ".extname" do
    assert_equal("kl", Munge::Util::Path.extname("ab.cd/ef/gh.ij.kl"))
    assert_equal("", Munge::Util::Path.extname("ab.cd/ef/gh"))
    assert_equal("cd", Munge::Util::Path.extname("ab.cd"))
    assert_equal("", Munge::Util::Path.extname("ab."))
  end

  test ".extnames" do
    assert_equal(%w(ij kl), Munge::Util::Path.extnames("ab.cd/ef/gh.ij.kl"))
  end

  test ".basename" do
    assert_equal("foo.rb", Munge::Util::Path.basename("foo.rb"))
    assert_equal("foo.rb", Munge::Util::Path.basename("bar/foo.rb"))
  end

  test ".basename_no_extension" do
    assert_equal("foo", Munge::Util::Path.basename_no_extension("foo.rb"))
    assert_equal("bar", Munge::Util::Path.basename_no_extension("foo/bar.rb"))
    assert_equal("bar", Munge::Util::Path.basename_no_extension("foo/bar"))
    assert_equal("bar", Munge::Util::Path.basename_no_extension("foo/bar."))
    assert_equal("", Munge::Util::Path.basename_no_extension(""))
  end

  test ".path_no_extension" do
    assert_equal("foo", Munge::Util::Path.path_no_extension("foo.rb"))
    assert_equal("foo/bar", Munge::Util::Path.path_no_extension("foo/bar.rb"))
    assert_equal("foo/bar", Munge::Util::Path.path_no_extension("foo/bar"))
    assert_equal("foo/bar.", Munge::Util::Path.path_no_extension("foo/bar."))
  end

  test ".ensure_abspath" do
    assert_equal("/foo/bar.", Munge::Util::Path.ensure_abspath("foo/bar."))
    assert_equal("/foo/bar", Munge::Util::Path.ensure_abspath("/foo//bar"))
  end

  test ".ensure_relpath" do
    assert_equal("foo/bar.", Munge::Util::Path.ensure_relpath("/foo/bar."))
    assert_equal("foo/bar", Munge::Util::Path.ensure_relpath("//foo//bar"))
    assert_equal("foo/bar", Munge::Util::Path.ensure_relpath("foo//bar"))
  end

  test ".join" do
    assert_equal("foo/bar", Munge::Util::Path.join("foo", "", "bar"))
  end
end
