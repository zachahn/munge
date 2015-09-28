module Munge
  module Core
    class Write
      def initialize(output, index)
        @output = output
        @index  = index
      end

      def write(route, content)
        relpath = resolve_filepath(route)
        abspath = File.join(@output, relpath)

        FileUtils.mkdir_p(File.dirname(abspath))

        if File.exist?(abspath) && File.read(abspath) == content
          return false
        else
          File.write(abspath, content)
          true
        end
      end

      def resolve_filepath(preferred_filename)
        basename = File.basename(preferred_filename)

        if basename.include?(".")
          preferred_filename
        else
          "#{preferred_filename}/#{@index}"
        end
      end
    end
  end
end
