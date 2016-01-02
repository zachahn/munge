module Munge
  module Core
    class ItemFactory
      class ContentParser
        def self.match(string)
          string.match(/
            # Start of string
            \A
            # Begin frontmatter
            (?:^---\s*[\n\r]+)
            # Capture frontmatter
            (.*)
            # End frontmatter
            (?:^---\s*[\n\r]+)
            /mx)
        end

        def self.parse(string)
          matchdata = match(string)

          [
            parse_frontmatter(matchdata),
            parse_content(matchdata, string)
          ]
        end

        def self.parse_frontmatter(matchdata)
          return {} if matchdata.nil?

          parsed_frontmatter = YAML.load(matchdata[1])

          frontmatter_hash =
            if parsed_frontmatter.is_a?(Hash)
              parsed_frontmatter
            else
              {}
            end

          Munge::Util::SymbolHash.deep_convert(frontmatter_hash)
        end

        def self.parse_content(matchdata, string)
          if matchdata
            matchdata.post_match
          else
            string
          end
        end

        def initialize(string)
          @frontmatter, @content = self.class.parse(string)
        end

        attr_accessor :frontmatter, :content
      end
    end
  end
end
