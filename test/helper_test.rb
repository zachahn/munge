require "test_helper"

class HelperTest < Minitest::Test
  module Container
    module Example1
      def one
      end
    end

    module Example2
      def two
      end
    end
  end

  def test_that_it_loads_stuff
    obj = Object.new

    refute_respond_to obj, :one
    refute_respond_to obj, :two

    Munge::Helper.load(obj, Container)

    assert_respond_to obj, :one
    assert_respond_to obj, :two
  end
end
