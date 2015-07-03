module Gramz
  module CFG
    module Symbol
      class Base
        attr_reader :symbol
        def initialize(sym)
          @symbol = sym.to_sym
        end

        def eql?(other)
          terminal? == other.terminal? && @symbol.eql?(other.symbol)
        end
        alias_method :==, :eql?

        def hash
          @symbol.hash
        end

        def to_sym
          @symbol.to_sym
        end

        def to_s
          @symbol.to_s
        end

        def non_terminal?
          !terminal?
        end
      end

      class Terminal < Base
        def terminal?
          true
        end
      end

      class NonTerminal < Base
        def terminal?
          false
        end
      end

      Start = NonTerminal.new(:"0")
      def Start.inspect
        "#<CFG::Symbol::Start>"
      end

      End = Terminal.new(:"$")
      def End.inspect
        "#<CFG::Symbol::End>"
      end
    end
  end
end
