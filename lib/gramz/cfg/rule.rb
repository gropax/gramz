require_relative 'rule/alternative'
require_relative 'rule/meta_symbols'

module Gramz
  module CFG
    class Rule
      include Conversions

      RuleError = Class.new(StandardError)

      attr_reader :left_symbol, :right_symbols

      def initialize(lsym, rsyms = [])
        @left_symbol = lsym
        @right_symbols = rsyms
      end

      def symbols
        [@left_symbol, *@right_symbols]
      end

      def ==(other)
        @left_symbol == other.left_symbol &&
          @right_symbols == other.right_symbols
      end
      alias_method :eql?, :==

      def hash
        [@left_symbol, @right_symbols].hash
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
