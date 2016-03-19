require "test_helper"

class RunnerTest < Minitest::Test
  def test_write
    File.stub(:read, "content") do
      File.stub(:exist?, true) do
        runner =
          Munge::Runner.new(
            items: dummy_items,
            router: dummy_router,
            alterant: dummy_alterant,
            writer: dummy_writer,
            reporter: Munge::Reporters::Default.new,
            destination: "anywhere"
          )

        FakeFS do
          @out, @err = capture_io { runner.write }
        end

        assert_match "wrote /true-file\n", @out
        assert_match "identical /false-file\n", @out
      end
    end
  end

  def test_dry_run
    skip
  end

  private

  def dummy_items
    [
      OpenStruct.new(route: "/true-file", content: "different content"),
      OpenStruct.new(route: "/false-file", content: "content")
    ]
  end

  def dummy_router
    QuickDummy.new(
      filepath: -> (item) { item.route }
    )
  end

  def dummy_alterant
    QuickDummy.new(
      transform: -> (item) { item.content }
    )
  end

  def dummy_writer
    QuickDummy.new(
      write: -> (_path, _content) { nil }
    )
  end
end
