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

  def output_path
    File.join(example_path, "dest")
  end

  def layouts_path
    File.join(example_path, "layouts")
  end

  def new_item(item_path)
    abspath = File.join(source_path, item_path)
    new_item_factory.read(abspath)
  end

  def new_fixture_item(item_path)
    abspath = File.join(old_fixtures_path, item_path)
    new_item_factory(old_fixtures_path).read(abspath)
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

  def new_item_factory(path = source_path)
    Munge::ItemFactory.new(
      path,
      %w(jpg png gif),
      :fs_memory,
      %w(index)
    )
  end

  def new_scope_factory(global_data)
    Munge::Core::TransformScopeFactory.new(
      source_path: source_path,
      layouts_path: layouts_path,
      global_data: global_data,
      source: new_source,
      helper_container: Munge::Helper,
      router: new_router
    )
  end

  def new_tilt_scope(global_data, source)
    new_scope_factory(global_data).create
  end

  def new_tilt_transformer(global_data)
    Munge::Transformer::Tilt.new(new_scope_factory(global_data))
  end

  def new_config
    Munge::Core::Config.new(File.join(example_path, "config.yml"))
  end

  def new_router(index_extensions: nil, index_basename: nil)
    config = new_config

    Munge::Core::Router.new(
      index: config[:index],
      keep_extensions: config[:keep_extensions]
    )
  end
end
