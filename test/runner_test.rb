require "test_helper"

class RunnerTest < Minitest::Test
  def test_write
    runner =
      Munge::Runner.new(
        source: dummy_source,
        router: dummy_router,
        alterant: dummy_alterant,
        writer: dummy_writer
      )

    FakeFS do
      @out, @err = capture_io { runner.write }
    end

    assert_match "wrote /true-file\n", @out
    assert_match "identical /false-file\n", @out
  end

  def test_dry_run
    skip
  end

  private

  def dummy_source
    [
      OpenStruct.new(route: "/true-file", did_write: true),
      OpenStruct.new(route: "/false-file", did_write: false)
    ]
  end

  def dummy_router
    QuickDummy.new(
      filepath: -> (item) { item.route }
    )
  end

  def dummy_alterant
    QuickDummy.new(
      transform: -> (item) { item.did_write }
    )
  end

  def dummy_writer
    QuickDummy.new(
      write: -> (path, content) { return content }
    )
  end
end
