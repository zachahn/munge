require "test_helper"

class ErrorsTest < TestCase
  test "#message of ErrorWithIdentifier" do
    error_classes = ObjectSpace.each_object(Class).select { |klass| klass < Munge::Errors::ErrorWithIdentifier }

    error_classes.each do |error_class|
      error = error_class.new("@@ ## $$ %%")
      assert_includes(error.message, "@@ ## $$ %%")
    end
  end
end
