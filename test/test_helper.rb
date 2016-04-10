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
require "munge/cli"

require "fakefs/safe"
require "minitest/autorun"
require "sass"
require "tilt/erb"
require "tilt/plain"
require "tilt/redcarpet"

require "ostruct"
require "securerandom"

require_relative "support/declarative"
require_relative "support/quick_dummy"

class Minitest::Test
  extend Declarative

  def seeds_path
    File.absolute_path(File.expand_path("../../seeds", __FILE__))
  end
end
