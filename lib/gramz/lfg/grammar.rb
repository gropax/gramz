module Gramz
  module LFG
    class Grammar
      attr_reader :initial_symbol

      def initialize(initial, rules)
        @initial_symbol = initial
        @rules = rules.group_by &:symbol
      end

      def rules
        @rules.values.flatten
      end

      def rules_for(symbol)
        @rules.fetch(symbol, [])
      end

      def accepts?(str)
        Parser.new(self, str).parse
      end

      def initial_rule
        Rule.new(
          Symbol::NonTerminal.new(:"0"),
          [Node.new(@initial_symbol)]
        )
      end
    end
  end
end
