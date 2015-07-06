module Gramz
  module CFG
    class Rule
      class MetaSymbol
        attr_reader :symbol
        def initialize(sym)
          @symbol = sym
        end
      end

      KleeneStar = Class.new MetaSymbol
      KleenePlus = Class.new MetaSymbol
      Optional   = Class.new MetaSymbol
    end
  end
end
