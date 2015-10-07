if ENV["CODECLIMATE_REPO_TOKEN"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start do
    add_filter do |src|
      src.filename =~ %r(^#{SimpleCov.root}/test)
    end
  end
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "munge"

require "minitest/autorun"

require "fakefs/safe"

require "tilt/erb"
require "tilt/plain"
require "tilt/redcarpet"

class Minitest::Test
  def example_path
    File.absolute_path(File.expand_path("../example", __FILE__))
  end

  def old_fixtures_path
    File.absolute_path(File.expand_path("../fixtures", __FILE__))
  end

  def source_path
    File.join(example_path, "src")
  end

  def layouts_path
    File.join(example_path, "layouts")
  end

  def new_item(item_path)
    abspath = File.join(source_path, item_path)
    new_item_factory.read(abspath)
  end

  def new_source
    Munge::Core::Source.new(source_path, [], :fs_memory, [])
  end

  def new_core_transformer(source)
    Munge::Core::Transform.new(
      source_path,
      layouts_path,
      { global: "data" },
      source
    )
  end

  def new_item_factory
    Munge::ItemFactory.new(
      source_path,
      %w(jpg png gif),
      :fs_memory,
      %w(index)
    )
  end

  def new_scope_factory(global_data)
    Munge::Core::TransformScopeFactory.new(
      source_path,
      layouts_path,
      global_data,
      new_source,
      Munge::Helper
    )
  end

  def new_tilt_scope(global_data, source)
    Munge::Transformer::Tilt::Scope.new(
      source_path,
      layouts_path,
      global_data,
      source
    )
  end

  def new_tilt_transformer(global_data)
    Munge::Transformer::Tilt.new(new_scope_factory(global_data))
  end
end
