require "test_helper"

class IntegrationSeedsTest < Minitest::Test
  def output_path
    File.join(seeds_path, "dest")
  end

  def test_integration
    FakeFS do
      FakeFS::FileSystem.clone(seeds_path)

      @out, @err = capture_io do
        Munge::Runner.write(seeds_path)
      end

      @index = File.read(File.join(output_path, "index.html"))
      style_path = Dir.glob(File.join(output_path, "assets/stylesheets", "basic*.css"))[0]
      @style = File.read(style_path)
    end

    assert_match %r{<title>Munge</title>}, @index, "output is missing layout"
    assert_match %r{<h1>Welcome</h1>}, @index, "output is missing content"
    assert_match(/background-color: ?#fff/, @style, "CSS is wrong")
  end
end
