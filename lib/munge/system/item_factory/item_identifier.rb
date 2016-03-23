module Munge
  class System
    class ItemFactory
      class ItemIdentifier
        def initialize(remove_extensions:)
          @remove_extension_regex = join_regex_strings(remove_extensions)
        end

        def call(relpath)
          dirname    = Munge::Util::Path.dirname(relpath)
          basename   = Munge::Util::Path.basename_no_extension(relpath)
          extensions = Munge::Util::Path.extnames(relpath)

          filtered_extensions =
            extensions
              .map    { |ext| @remove_extension_regex.match(ext) || ext }
              .select { |ext| ext.is_a?(String) }

          new_basename =
            [basename, *filtered_extensions].join(".")

          Munge::Util::Path.join(dirname, new_basename)
        end

        private

        def join_regex_strings(strings)
          regexes =
            strings
              .map { |str| "\\A#{str}\\Z" }
              .map { |str| Regexp.new(str) }

          Regexp.union(regexes)
        end
      end
    end
  end
end
