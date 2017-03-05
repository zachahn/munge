require "test_helper"

class CliCommandsInitTest < TestCase
  test "it copies files over" do
    FakeFS do
      FakeFS::FileSystem.clone(seeds_path)

      Dir.mkdir(fake_path)
      Dir.chdir(fake_path) do
        capture_io do
          Gem::Specification.stub(:find_all_by_name, []) do
            command.call
          end
        end
      end

      @gemfile = File.read(File.join(fake_path, "Gemfile"))
      @rules   = File.read(File.join(fake_path, "rules.rb"))
    end

    assert_match(/^gem "munge"/, @gemfile)
    refute_match(/VERSION/, @gemfile)
    assert_match(/app\./, @rules)
  end

  private

  def fake_path
    @path ||= "/#{SecureRandom.hex(10)}"
  end

  def command
    command_class.new(fake_path)
  end

  def command_class
    Munge::Cli::Commands::Init
  end
end
