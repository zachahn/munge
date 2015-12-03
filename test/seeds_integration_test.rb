require "test_helper"

class SeedsIntegrationTest < Minitest::Test
  def rules_path
    File.join(seeds_path, "rules.rb")
  end

  def output_path
    File.join(seeds_path, "dest")
  end

  def test_integration
    FakeFS do
      FakeFS::FileSystem.clone(seeds_path)

      app = Munge::Application.new("#{seeds_path}/config.yml")

      binding.eval(File.read(rules_path), rules_path)

      app.write

      @index = File.read(File.join(output_path, "index.html"))
    end

    assert_match %r(<title>Munge</title>), @index, "output is missing layout"
    assert_match %r(<h1>Welcome</h1>), @index, "output is missing content"
  end
end
