require "test_helper"

class CoreItemFactoryContentParserTest < Minitest::Test
  def test_content_parser_reads_frontmatter
    match = Munge::Core::ItemFactory::ContentParser.new(
      %(---
this: is
yaml: frontmatter
---
but this is not yay
)
    )

    assert_equal({ "this" => "is", "yaml" => "frontmatter" }, match.frontmatter)
    assert_equal("but this is not yay\n", match.content)
  end

  def test_content_parser_reads_nonfrontmatter
    match = Munge::Core::ItemFactory::ContentParser.new(
      "yay this is cool lol"
    )

    assert_equal({}, match.frontmatter)
    assert_equal("yay this is cool lol", match.content)
  end

  def test_content_parser_reads_nonfrontmatter_with_weird_dashes
    match = Munge::Core::ItemFactory::ContentParser.new(
      %(baa baa

---

black sheep
---
have you any wool)
    )

    assert_equal({}, match.frontmatter)
    assert_equal("baa baa\n\n---\n\nblack sheep\n---\nhave you any wool",
      match.content)
  end

  def test_content_parser_that_looks_like_frontmatter_but_really_isnt
    match = Munge::Core::ItemFactory::ContentParser.new(
      %(---
not frontmatter
---

yup)
    )

    assert_equal({}, match.frontmatter)
    assert_equal("yup", match.content)
  end
end
