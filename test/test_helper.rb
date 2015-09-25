require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

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

  def source_path
    File.join(example_path, "src")
  end

  def layouts_path
    File.join(example_path, "layouts")
  end

  def new_item(item_path)
    file = "#{source_path}/#{item_path}"

    Munge::Item::Text.new(
      Munge::Attribute::Path.new(source_path, file),
      Munge::Attribute::Content.new(File.read(file)),
      Munge::Attribute::Metadata.new(file)
    )
  end
end
