require "test_helper"

class BootloaderTest < TestCase
  def test_initialize_from_dir
    bootloader = Munge::Bootloader.new(
      root_path: seeds_path
    )

    assert_kind_of(Munge::Init, bootloader.init)
    assert_kind_of(Hash, bootloader.config)
  end
end
