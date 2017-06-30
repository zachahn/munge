require "test_helper"

class LoadTest < TestCase
  test "works" do
    loader = Munge::Load.new(seeds_path)

    loader.app do |application, conglomerate|
      assert_kind_of(Munge::Application, application)
      assert_kind_of(Munge::Conglomerate, conglomerate)
    end
  end
end
