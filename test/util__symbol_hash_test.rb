require "test_helper"

class UtilSymbolHashTest < TestCase
  test "basic" do
    pre = { "a" => "b", "c" => "d" }
    post = { a: "b", c: "d" }

    assert_equal(post, Munge::Util::SymbolHash.deep_convert(pre))
  end

  test "with number key" do
    pre = { "a" => "b", 1 => "c" }
    post = { a: "b", 1 => "c" }

    assert_equal(post, Munge::Util::SymbolHash.deep_convert(pre))
  end

  test "nested" do
    pre = { "a" => "b", "c" => { "d" => "e" } }
    post = { a: "b", c: { d: "e" } }

    assert_equal(post, Munge::Util::SymbolHash.deep_convert(pre))
  end

  test "array of hashes" do
    pre = { "a" => [{ "b" => "c" }] }
    post = { a: [{ b: "c" }] }

    assert_equal(post, Munge::Util::SymbolHash.deep_convert(pre))
  end
end
