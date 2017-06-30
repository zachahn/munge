require "test_helper"

class FunctionWriteTest < TestCase
  test "#call with new file" do
    dummy_vfs = QuickDummy.new(**vfs_exist_false, **vfs_write_noop)
    r = new_runner(dummy_vfs)

    out, _err = capture_io { r.call }

    assert_equal("new /about\n", out)
  end

  test "#call with updated file" do
    dummy_vfs = QuickDummy.new(**vfs_exist_true, **vfs_read_diff, **vfs_write_noop)
    r = new_runner(dummy_vfs)

    out, _err = capture_io { r.call }

    assert_equal("changed /about\n", out)
  end

  test "#call with identical file" do
    dummy_vfs = QuickDummy.new(**vfs_exist_true, **vfs_read_same, **vfs_write_noop)
    r = new_runner(dummy_vfs)

    out, _err = capture_io { r.call }

    assert_equal("identical /about\n", out)
  end

  test "#call with double write error" do
    dummy_vfs = QuickDummy.new(**vfs_exist_true, **vfs_read_diff, **vfs_write_noop)
    r = new_runner(dummy_vfs, [new_item, new_item])

    assert_raises(Munge::Error::DoubleWriteError) { capture_io { r.call } }
  end

  private

  def new_runner(vfs = Munge::Vfs::DryRun.new(Munge::Vfs::Filesystem.new("anything")), items = [new_item])
    conglomerate = OpenStruct.new
    conglomerate.items = items
    conglomerate.router = dummy_router
    conglomerate.processor = dummy_processor

    Munge::Function::Write.new(
      conglomerate: conglomerate,
      reporter: Munge::Reporter.new(formatter: new_formatter, verbosity: :all),
      manager: Munge::WriteManager::OnlyNeeded.new(vfs),
      destination: vfs
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

  def vfs_exist_true
    { exist?: -> (*) { true } }
  end

  def vfs_exist_false
    { exist?: -> (*) { false } }
  end

  def vfs_read_diff
    { read: -> (*) { "cool" } }
  end

  def vfs_read_same
    { read: -> (*) { "I am the best" } }
  end

  def vfs_write_noop
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
