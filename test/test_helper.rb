require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "munge"

require "minitest/autorun"

require "fakefs/safe"

require "tilt/erb"
require "tilt/plain"
require "tilt/redcarpet"
