require "test_helper"

class RunnerTest < TestCase
  test "#write with new file" do
    r = new_runner
    r.instance_variable_set(:@write_manager, dummy_write_manager)

    out, _err = capture_io { r.write }

    assert_equal("new /about\nnew /about\n", out)
  end

  test "#write with updated file" do
    r = new_runner
    r.instance_variable_set(:@write_manager, dummy_write_manager_changed)

    out, _err = capture_io { r.write }

    assert_equal("changed /about\nchanged /about\n", out)
  end

  test "#write with identical file" do
    r = new_runner
    r.instance_variable_set(:@write_manager, dummy_write_manager_identical)

    out, _err = capture_io { r.write }

    assert_equal("identical /about\nidentical /about\n", out)
  end

  test "#write with double write error" do
    r = new_runner
    r.instance_variable_set(:@write_manager, dummy_write_manager_double_write_error)

    assert_raises { r.write }
  end

  private

  def new_runner
    Munge::Runner.new(
      items: [new_item, new_item],
      router: dummy_router,
      processor: dummy_processor,
      writer: Munge::Writers::Noop.new,
      formatter: new_formatter,
      verbosity: :all,
      destination: "anywhere"
    )
  end

  def new_item
    OpenStruct.new(route: "/about", content: "I am the best")
  end

  def dummy_router
    QuickDummy.new(
      filepath: -> (item) { item.route },
      route: -> (item) { item.route }
    )
  end

  def dummy_processor
    QuickDummy.new(
      transform: -> (item) { item.content }
    )
  end

  def dummy_write_manager
    QuickDummy.new(
      status: -> (_, _) { :new }
    )
  end

  def dummy_write_manager_changed
    QuickDummy.new(
      status: -> (_, _) { :changed }
    )
  end

  def dummy_write_manager_identical
    QuickDummy.new(
      status: -> (_, _) { :identical }
    )
  end

  def dummy_write_manager_double_write_error
    QuickDummy.new(
      status: -> (_, _) { :double_write_error }
    )
  end

  def new_formatter
    QuickDummy.new(
      start: -> {},
      done: -> {},
      call: lambda do |item, _relpath, write_status, _should_write|
        puts "#{write_status} #{item.route}"
      end
    )
  end
end
