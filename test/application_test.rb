require "test_helper"

class ApplicationTest < Minitest::Test
  def output_path
    File.join(example_path, "dest")
  end

  def test_create
    application = Munge::Application.new("#{example_path}/config.yml")

    count = application.source.count

    application.create(
      relpath: "foo/bar.html",
      content: "x",
      frontmatter: {}
    )

    new_count = application.source.count

    assert_equal count + 1, new_count
  end

  def test_integration
    FakeFS do
      FakeFS::FileSystem.clone(example_path)

      app = Munge::Application.new("#{example_path}/config.yml")

      about_item = app.source["about"]
      about_item.route = about_item.id
      about_item.transform

      home_item = app.source[""]
      home_item.route = home_item.id
      home_item.transform
      home_item.layout = "basic"

      tgif_item = app.source["transparent.gif"]
      tgif_item.route = tgif_item.id

      cant_find_item = app.source["frontmatter_and_markdown"]
      cant_find_item.route = "justdance.html"
      cant_find_item.transform
      cant_find_item.layout = "req_global_data"

      app.write

      # puts Dir["#{output_path}/**/*"].join("\n")

      @about       = File.read("#{output_path}/about/index.html")
      @transparent = File.read("#{output_path}/transparent--3eacd0132310ea44cad756b378a3bc07.gif")
      @index       = File.read("#{output_path}/index.html")
      @justdance   = File.read("#{output_path}/justdance.html")
    end

    assert_equal "<h1>about me</h1>\n", @about
    assert_equal 37, @transparent.size
    assert_equal "<body>hi</body>\n", @index
    assert_equal "<body>this is a test<p><strong>cant find</strong> my drink or man</p>\n</body>\n", @justdance
  end
end
