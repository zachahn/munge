require "test_helper"

module CommandInterfaceTest
  extend Declarative

  test "#call interface" do
    cmd = command

    assert_respond_to(cmd, :call)
    assert_equal([], cmd.method(:call).parameters)
  end
end
