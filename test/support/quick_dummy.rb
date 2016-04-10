class QuickDummy
  def initialize(**args)
    args.each do |method_name, definition|
      define_singleton_method(method_name, definition)
    end
  end
end
