require "test_helper"
require "munge/attribute/metadata"

class AttributeMetadataTest < Minitest::Test
  def setup
    @metadata = Munge::Attribute::Metadata.new(__FILE__)
  end

  def test_stat_is_of_class_file_stat
    assert_instance_of File::Stat, @metadata.stat
  end
end
