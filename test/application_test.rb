require "test_helper"

class ApplicationTest < Minitest::Test
  def test_create
    application = Munge::Application.new("#{example_path}/config.yml")

    count = application.source.count

    application.create("foo/bar.html", "x", {}, type: :binary)

    new_count = application.source.count

    assert_equal count + 1, new_count
  end

  def test_integration
    FakeFS do
      FakeFS::FileSystem.clone(example_path)

      app = Munge::Application.new("#{example_path}/config.yml")

      app.source
        .select { |item| item.extensions.include?("html") }
        .each   { |item| item.route = item.id }
        .each   { |item| item.transform }

      app.source
        .select { |item| item.type == :binary }
        .each   { |item| item.route = item.id }

      app.source
        .select { |item| item.id == "md_no_ext" }
        .each   { |item| item.route = item.id }
        .each   { |item| item.transform(:tilt, "md") }

      app.write

      # puts Dir["#{output_path}/**/*"].join("\n")

      @about       = File.read("#{output_path}/about/index.html")
      @transparent = File.read("#{output_path}/transparent.gif")
      @index       = File.read("#{output_path}/index.html")
      @md_no_ext   = File.read("#{output_path}/md_no_ext/index.html")
    end

    assert_equal "<h1>about me</h1>\n", @about
    assert_equal 37, @transparent.size
    assert_equal "hi", @index
    assert_equal "<h1>hi</h1>\n", @md_no_ext
  end
end
