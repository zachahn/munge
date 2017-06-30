require "test_helper"

class ConglomerateItemFactoryContentParserTest < TestCase
  test "ContentParser reads formatter" do
    match = Munge::Conglomerate::ItemFactory::ContentParser.new(
      %(---
this: is
yaml: frontmatter
---
but this is not yay
)
    )

    assert_equal({ this: "is", yaml: "frontmatter" }, match.frontmatter)
    assert_equal("but this is not yay\n", match.content)
  end

  test "ContentParser can read when there's no frontmatter" do
    match = Munge::Conglomerate::ItemFactory::ContentParser.new(
      "yay this is cool lol"
    )

    assert_equal({}, match.frontmatter)
    assert_equal("yay this is cool lol", match.content)
  end

  test "ContentParser can handle weird dashes" do
    match = Munge::Conglomerate::ItemFactory::ContentParser.new(
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

  test "ContentParser ignores 'fake' frontmatter" do
    match = Munge::Conglomerate::ItemFactory::ContentParser.new(
      %(---
not frontmatter
---

yup)
    )

    assert_equal({}, match.frontmatter)
    assert_equal("yup", match.content)
  end
end
