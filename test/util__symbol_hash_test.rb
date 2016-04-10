require "test_helper"

class UtilSymbolHashTest < TestCase
  def test_basic
    pre  = { "a" => "b", "c" => "d" }
    post = { a: "b", c: "d" }

    assert_equal(post, Munge::Util::SymbolHash.deep_convert(pre))
  end

  def test_with_number
    pre  = { "a" => "b", 1 => "c" }
    post = { a: "b", 1 => "c" }

    assert_equal(post, Munge::Util::SymbolHash.deep_convert(pre))
  end

  def test_nested
    pre  = { "a" => "b", "c" => { "d" => "e" } }
    post = { a: "b", c: { d: "e" } }

    assert_equal(post, Munge::Util::SymbolHash.deep_convert(pre))
  end

  def test_array_of_hashes
    pre  = { "a" => [{ "b" => "c" }] }
    post = { a: [{ b: "c" }] }

    assert_equal(post, Munge::Util::SymbolHash.deep_convert(pre))
  end
end
