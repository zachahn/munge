class WriteManagerTest < TestCase
  def test_identical
    wm = Munge::WriteManager.new(driver: dummy_driver_exists)
    first_write = wm.status("foo.txt", "content")

    assert_equal(:identical, first_write)
  end

  def test_different
    wm = Munge::WriteManager.new(driver: dummy_driver_exists)
    first_write = wm.status("foo.txt", "different content")

    assert_equal(:changed, first_write)
  end

  def test_not_exists
    wm = Munge::WriteManager.new(driver: dummy_driver_dne)
    first_write = wm.status("foo.txt", "content")

    assert_equal(:new, first_write)
  end

  def test_no_duplicates
    wm = Munge::WriteManager.new(driver: dummy_driver_exists)
    first_write  = wm.status("foo.txt", "bar")
    second_write = wm.status("foo.txt", "test")

    assert_equal(:changed, first_write)
    assert_equal(:double_write_error, second_write)
  end

  private

  def dummy_driver_exists
    QuickDummy.new(
      exist?: -> (_) { true },
      read:   -> (_) { "content" }
    )
  end

  def dummy_driver_dne
    QuickDummy.new(
      exist?: -> (_) { false },
      read:   -> (_) { "content" }
    )
  end
end
