module Munge
  module Util
    module Import
      # Loads file into current scope. Similar to `load "filename.rb"`
      #
      # @param absolute_file_path [String]
      # @param execution_context [Binding]
      # @return [void]
      def import_to_context(absolute_file_path, execution_context)
        contents = File.read(absolute_file_path)
        execution_context.eval(contents, absolute_file_path)
      end
    end
  end
end
