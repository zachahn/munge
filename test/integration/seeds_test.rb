require "test_helper"

class IntegrationSeedsTest < TestCase
  test "integration" do
    Dir.mktmpdir do |tmpdir|
      FileUtils.copy_entry(seeds_path, tmpdir)
      @path = tmpdir

      @out, @err = capture_io do
        Munge::Cli::Commands::Build.new(
          bootloader,
          reporter: "Default",
          verbosity: "all",
          dry_run: false
        ).call
      end

      @index = File.read(File.join(output_path, "index.html"))
      style_path = Dir.glob(File.join(output_path, "assets", "basic*.css"))[0]
      @style = File.read(style_path)
    end

    assert_match(%r{<title>Munge</title>}, @index, "output is missing layout")
    assert_match(%r{<h1>Woohoo!</h1>}, @index, "output is missing content")
    assert_match(/background-color: ?#fff/, @style, "CSS is wrong")
  end

  test "dry run doesn't write any files" do
    Dir.mktmpdir do |tmpdir|
      FileUtils.copy_entry(seeds_path, tmpdir)
      @path = tmpdir

      @out, @err = capture_io do
        Munge::Cli::Commands::Build.new(
          bootloader,
          reporter: "Default",
          verbosity: "all",
          dry_run: true
        ).call
      end

      @files = Dir.glob(File.join(output_path, "**/*"))
    end

    assert_equal([], @files)
    refute_equal("", @out)
    assert_equal("", @err)
  end

  private

  def fake_path
    @path ||= "/#{SecureRandom.hex(10)}"
  end

  def output_path
    File.join(fake_path, "dest")
  end

  def bootloader
    Munge::Bootloader.new(root_path: fake_path)
  end
end
