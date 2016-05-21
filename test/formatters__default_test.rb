require "test_helper"

class FormattersDefaultTest < TestCase
  include FormatterInterfaceTest

  test "#start output" do
    out, _err = capture_io do
      formatter.start
    end

    assert_equal("Started build\n", out)
  end

  test "#done output" do
    out, _err = capture_io do
      Timecop.freeze do
        f = formatter
        f.start
        f.instance_variable_set(:@start_time, Time.now - 10)
        f.instance_variable_set(:@new_count, 100)
        f.instance_variable_set(:@changed_count, 200)
        f.instance_variable_set(:@identical_count, 300)
        f.done
      end
    end

    assert_equal("Started build\nWrote 300, Processed 600\nTook 10.0 seconds\n", out)
  end

  test "#call output with :new file" do
    out, _err = capture_io do
      formatter.call(new_item, "path/to/index.html", :new, true)
    end

    assert_equal("        \e[32mcreated\e[0m   path/to/index.html\n", out)
  end

  test "#call output with :changed file" do
    out, _err = capture_io do
      formatter.call(new_item, "path/to/index.html", :changed, true)
    end

    assert_equal("        \e[32mupdated\e[0m   path/to/index.html\n", out)
  end

  test "#call output with :identical file" do
    out, _err = capture_io do
      formatter.call(new_item, "path/to/index.html", :identical, true)
    end

    assert_equal("      \e[33midentical\e[0m   path/to/index.html\n", out)
  end

  private

  def formatter_class
    Munge::Formatters::Default
  end
end
