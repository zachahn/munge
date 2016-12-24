require "test_helper"

module TransformerInterfaceTest
  extend Declarative

  test "#name interface" do
    assert_kind_of(Symbol, new_transformer.name)
  end

  test "#call interface" do
    m = new_transformer.method(:call).parameters
    parameter_types = m.map(&:first)

    assert(parameter_types.length >= 2)
    assert_equal(:req, parameter_types[0])
    assert_equal(:req, parameter_types[1])
  end
end
