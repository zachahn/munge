require "test_helper"

module FormatterInterfaceTest
  extend Declarative

  test "#start interface" do
    assert_respond_to(formatter, :start)
  end

  test "#call interface" do
    assert_respond_to(formatter, :call)
    assert_equal(4, formatter.method(:call).arity)
  end

  test "#done interface" do
    assert_respond_to(formatter, :done)
  end

  test "#start #call #done in sequence" do
    f = formatter

    capture_io do
      f.start
      f.call(new_item, "path/to/index.html", :new, true)
      f.done
    end
  end

  test "#start #call #done in sequence with all types and all should/shouldn't prints" do
    f = formatter

    capture_io do
      f.start
      f.call(new_item, "path/to/index.html", :new, true)
      f.call(new_item, "path/to/index.html", :changed, true)
      f.call(new_item, "path/to/index.html", :identical, true)
      f.call(new_item, "path/to/index.html", :new, false)
      f.call(new_item, "path/to/index.html", :changed, false)
      f.call(new_item, "path/to/index.html", :identical, false)
      f.done
    end
  end

  test "#start #done in sequence" do
    f = formatter

    capture_io do
      f.start
      f.done
    end
  end

  private

  def formatter
    formatter_class.new
  end

  def new_item
    Munge::Item.new(
      type: :text,
      relpath: "index.html",
      id: "index",
      content: "content"
    )
  end
end
