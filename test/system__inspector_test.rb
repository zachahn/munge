require "test_helper"

class SystemInspectorTest < TestCase
  test "handler runs if true" do
    called = false

    Pry.stub(:start, proc { called = true }) do
      l = Munge::System::Inspector.new
      l.handler(:test_event, if: true)
      l.breakpoint(:test_event, binding)
    end

    assert_equal(true, called)
  end

  test "handler doesn't run if false" do
    Pry.stub(:start, proc { raise "shouldn't call Pry.start" }) do
      l = Munge::System::Inspector.new
      l.handler(:test_event, if: false)
      l.breakpoint(:test_event, binding)
    end
  end

  test "handler runs if evaled string is truthy" do
    called = false

    Pry.stub(:start, proc { called = true }) do
      l = Munge::System::Inspector.new
      l.handler(:test_event, if: "derek == :zoolander")
      breakpoint_out_of_scope(l)
    end

    assert_equal(true, called)
  end

  test "handler doesn't run if evaled string is falsy" do
    Pry.stub(:start, proc { raise "shouldn't call Pry.start" }) do
      l = Munge::System::Inspector.new
      l.handler(:test_event, if: "derek == :jeter")
      breakpoint_out_of_scope(l)
    end
  end

  private

  def breakpoint_out_of_scope(inspector)
    derek = :zoolander

    inspector.breakpoint(:test_event, binding)
  end
end
