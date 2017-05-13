class UtilBooleanRegexTest < TestCase
  test ".match? returns true" do
    result = Munge::Util::BooleanRegex.match?(/yes/, "yes")

    assert_equal(true, result)
  end

  test ".match? returns false" do
    result = Munge::Util::BooleanRegex.match?(/yes/, "no")

    assert_equal(false, result)
  end
end
