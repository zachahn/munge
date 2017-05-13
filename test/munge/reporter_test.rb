require "test_helper"

class ReporterTest < TestCase
  test "#call prints everything when verbosity is `:all`" do
    r = Munge::Reporter.new(formatter: formatter, verbosity: :all)

    new = r.call(OpenStruct.new(route: "@@ITEM@@"), "a", :new)
    changed = r.call(OpenStruct.new(route: "@@ITEM@@"), "b", :changed)
    identical = r.call(OpenStruct.new(route: "@@ITEM@@"), "c", :identical)

    assert_equal(":new true @@ITEM@@", new)
    assert_equal(":changed true @@ITEM@@", changed)
    assert_equal(":identical true @@ITEM@@", identical)
  end

  test "#call prints only :new and :changed when verbosity is `:written`" do
    r = Munge::Reporter.new(formatter: formatter, verbosity: :written)

    new = r.call(OpenStruct.new(route: "@@ITEM@@"), "a", :new)
    changed = r.call(OpenStruct.new(route: "@@ITEM@@"), "b", :changed)
    identical = r.call(OpenStruct.new(route: "@@ITEM@@"), "c", :identical)

    assert_equal(":new true @@ITEM@@", new)
    assert_equal(":changed true @@ITEM@@", changed)
    assert_equal(":identical false @@ITEM@@", identical)
  end

  test "#call prints nothing when verbosity is `:silent`" do
    r = Munge::Reporter.new(formatter: formatter, verbosity: :silent)

    new = r.call(OpenStruct.new(route: "@@ITEM@@"), "a", :new)
    changed = r.call(OpenStruct.new(route: "@@ITEM@@"), "b", :changed)
    identical = r.call(OpenStruct.new(route: "@@ITEM@@"), "c", :identical)

    assert_equal(":new false @@ITEM@@", new)
    assert_equal(":changed false @@ITEM@@", changed)
    assert_equal(":identical false @@ITEM@@", identical)
  end

  test "#call prints nothing when verbosity is unknown" do
    r = Munge::Reporter.new(formatter: formatter, verbosity: :unknown)

    new = r.call(OpenStruct.new(route: "@@ITEM@@"), "a", :new)
    changed = r.call(OpenStruct.new(route: "@@ITEM@@"), "b", :changed)
    identical = r.call(OpenStruct.new(route: "@@ITEM@@"), "c", :identical)

    assert_equal(":new false @@ITEM@@", new)
    assert_equal(":changed false @@ITEM@@", changed)
    assert_equal(":identical false @@ITEM@@", identical)
  end

  private

  def formatter
    lambda do |item, _relpath, write_status, should_print|
      "#{write_status.inspect} #{should_print} #{item.route}"
    end
  end
end
