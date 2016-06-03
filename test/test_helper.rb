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
require "rack/test"
require "timecop"
require "sass"
require "tilt/erb"
require "tilt/plain"
require "tilt/redcarpet"
require "tilt/sass"

require "ostruct"
require "securerandom"

require_relative "support/declarative"
require_relative "support/quick_dummy"

require_relative "interfaces/command_interface_test"
require_relative "interfaces/formatter_interface_test"
require_relative "interfaces/router_interface_test"
require_relative "interfaces/transformer_interface_test"

class TestCase < Minitest::Test
  extend Declarative

  def seeds_path
    File.absolute_path(File.expand_path("../../seeds", __FILE__))
  end
end
