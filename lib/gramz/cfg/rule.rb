module Gramz
  module CFG
    class Rule
      include Conversions

      RuleError = Class.new(StandardError)

      attr_reader :left_symbol, :right_symbols

      def initialize(lh_sym, rh_syms = [])
        left_symbol = Symbol(lh_sym)
        right_symbols = rh_syms.map { |s| Symbol(s) }

        check_left_symbol_is_non_terminal! left_symbol

        @left_symbol = left_symbol
        @right_symbols = right_symbols
      end

      def check_left_symbol_is_non_terminal!(symbol)
        if symbol.terminal?
          raise RuleError, "Left hand side symbol should be non-terminal."
        end
      end

      def inspect(ljust = 0)
        "#{@left_symbol.to_s.ljust(ljust)} → #{@right_symbols.map(&:to_s).join(' ')}"
      end
    end
  end
end
