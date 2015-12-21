require "test_helper"

class RunnerTest < Minitest::Test
  def test_instantiation_of_application
    app = Munge::Runner.application(seeds_path)

    assert_kind_of Munge::Application, app
  end

  def test_missing_static_method
    FakeFS do
      FakeFS::FileSystem.clone(seeds_path)
      @out, @err = capture_io { Munge::Runner.write(seeds_path) }
    end

    assert_match "wrote /\n", @out
  end

  def test_write
    runner = Munge::Runner.new(dummy_application)

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
