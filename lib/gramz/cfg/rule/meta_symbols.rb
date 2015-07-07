module Gramz
  module CFG
    class Rule
      class MetaSymbol
        attr_reader :symbol
        def initialize(sym)
          @symbol = sym
        end

        def terminal?
          @symbol.terminal?
        end

        def non_terminal?
          @symbol.non_terminal?
        end
      end

      class KleeneStar < MetaSymbol
        def to_s
          "#{@symbol}*"
        end
      end

      class KleenePlus < MetaSymbol
        def to_s
          "#{@symbol}+"
        end
      end

      class Optional < MetaSymbol
        def to_s
          "(#{@symbol})"
        end
      end
    end
  end
end
