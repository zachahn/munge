require "test_helper"

class FormatterDotsTest < TestCase
  include FormatterInterfaceTest

  test "#start output" do
    out, _err = capture_io do
      formatter.start
    end

    assert_equal(out, "Building:\n")
  end

  test "#call always prints a `.` OR `W`" do
    print_dot = lambda do |status, print|
      out, _err = capture_io do
        formatter.call(new_item, "path/to/index.html", status, print)
      end

      out
    end

    assert_equal("\e[32mW\e[0m", print_dot.call(:new, true))
    assert_equal("\e[32mW\e[0m", print_dot.call(:new, false))
    assert_equal("\e[33mW\e[0m", print_dot.call(:changed, true))
    assert_equal("\e[33mW\e[0m", print_dot.call(:changed, false))
    assert_equal(".", print_dot.call(:identical, true))
    assert_equal(".", print_dot.call(:identical, false))
  end

  private

  def formatter_class
    Munge::Formatter::Dots
  end
end
