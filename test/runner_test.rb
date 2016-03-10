require "test_helper"

class RunnerTest < Minitest::Test
  def test_write
    runner =
      Munge::Runner.new(
        application: dummy_application
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

  def dummy_application
    app = Object.new

    def app.write
      yield [OpenStruct.new(route: "/true-file"), true]
      yield [OpenStruct.new(route: "/false-file"), false]
    end

    app
  end
end
