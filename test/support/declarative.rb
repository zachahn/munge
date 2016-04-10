module Declarative
  def test(name, &block)
    method_name = "test_#{name.gsub(/\s+/, "_")}"

    method_block =
      if block_given?
        block
      else
        Proc.new { skip "not defined" }
      end

    if method_defined?(method_name)
      raise %(test `#{method_name}` already defined)
    else
      define_method(method_name, &method_block)
    end
  end
end
