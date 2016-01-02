if ENV["CODECLIMATE_REPO_TOKEN"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start do
    add_filter do |src|
      src.filename =~ %r{^#{SimpleCov.root}/test}
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

class QuickDummy
  def initialize(**args)
    args.each do |method_name, definition|
      define_singleton_method(method_name, definition)
    end
  end
end

class Minitest::Test
  def seeds_path
    File.absolute_path(File.expand_path("../../seeds", __FILE__))
  end

  def example_path
    File.absolute_path(File.expand_path("../example", __FILE__))
  end
end
