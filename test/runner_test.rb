require "test_helper"

class RunnerTest < TestCase
  def test_write
    File.stub(:read, "content") do
      File.stub(:exist?, true) do
        runner =
          Munge::Runner.new(
            items: dummy_items,
            router: dummy_router,
            alterant: dummy_alterant,
            writer: dummy_writer,
            formatter: dummy_formatter,
            verbosity: :all,
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

  def dummy_formatter
    QuickDummy.new(
      start: -> {},
      done: -> {},
      call: lambda do |item, relpath, write_status, _should_write|
        case write_status
        when :new, :changed
          puts "wrote #{item.route}"
        else
          puts "identical #{item.route}"
        end
      end
    )
  end
end
