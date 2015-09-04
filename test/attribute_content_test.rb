require "test_helper"
require "munge/attribute/content"

class AttributeContentTest < Minitest::Test
  def test_content_parser_reads_frontmatter
    match = Munge::Attribute::Content.new(
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
    match = Munge::Attribute::Content.new(
      "yay this is cool lol"
    )

    assert_equal({}, match.frontmatter)
    assert_equal("yay this is cool lol", match.content)
  end

  def test_content_parser_reads_nonfrontmatter_with_weird_dashes
    match = Munge::Attribute::Content.new(
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
end
