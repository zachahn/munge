require "test_helper"

class RunnerTest < TestCase
  test "#write with new file" do
    dummy_io = QuickDummy.new(**io_exist_false, **io_write_noop)
    r = new_runner(dummy_io)

    out, _err = capture_io { r.write }

    assert_equal("new /about\n", out)
  end

  test "#write with updated file" do
    dummy_io = QuickDummy.new(**io_exist_true, **io_read_diff, **io_write_noop)
    r = new_runner(dummy_io)

    out, _err = capture_io { r.write }

    assert_equal("changed /about\n", out)
  end

  test "#write with identical file" do
    dummy_io = QuickDummy.new(**io_exist_true, **io_read_same, **io_write_noop)
    r = new_runner(dummy_io)

    out, _err = capture_io { r.write }

    assert_equal("identical /about\n", out)
  end

  test "#write with double write error" do
    dummy_io = QuickDummy.new(**io_exist_true, **io_read_diff, **io_write_noop)
    r = new_runner(dummy_io, [new_item, new_item])

    assert_raises(Munge::Errors::DoubleWriteError) { capture_io { r.write } }
  end

  private

  def new_runner(io = Munge::Io::Noop.new, items = [new_item])
    Munge::Runner.new(
      items: items,
      router: dummy_router,
      processor: dummy_processor,
      io: io,
      reporter: Munge::Reporter.new(formatter: new_formatter, verbosity: :all),
      destination: "anywhere",
      manager: Munge::WriteManager::OnlyNeeded.new(io)
    )
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

  def io_exist_true
    { exist?: -> (*) { true } }
  end

  def io_exist_false
    { exist?: -> (*) { false } }
  end

  def io_read_diff
    { read: -> (*) { "cool" } }
  end

  def io_read_same
    { read: -> (*) { "I am the best" } }
  end

  def io_write_noop
    { write: -> (*) {} }
  end

  def new_item
    OpenStruct.new(route: "/about", content: "I am the best")
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
