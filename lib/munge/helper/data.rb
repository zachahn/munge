module Munge
  module Helper
    module Data
      def globals
        @data_helper_globals ||=
          Munge::Util::SymbolHash.deep_convert(system.global_data)
      end
    end
  end
end
