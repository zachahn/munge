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

require "ostruct"

class Minitest::Test
  def example_path
    File.absolute_path(File.expand_path("../example", __FILE__))
  end

  def old_fixtures_path
    File.absolute_path(File.expand_path("../fixtures", __FILE__))
  end

  def output_path
    File.join(example_path, "dest")
  end

  def new_tilt_scope(global_data, source)
    new_scope_factory(global_data: global_data).create
  end

  def new_config
    Munge::Core::Config.new(File.join(example_path, "config.yml"))
  end

  def new_router(index_extensions: nil, index_basename: nil)
    config = new_config

    Munge::Core::Router.new(
      index:           config[:index],
      keep_extensions: config[:keep_extensions]
    )
  end
end
