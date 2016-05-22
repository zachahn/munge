require "test_helper"

module TransformerInterfaceTest
  extend Declarative

  test "#name interface" do
    assert_kind_of(Symbol, transformer.name)
  end

  test "#call interface" do
    m = transformer.method(:call).parameters
    parameter_types = m.map(&:first)
    assert_equal(%i(req opt opt), parameter_types)
  end
end
