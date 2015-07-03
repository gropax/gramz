module Gramz
  module CFG
    class Grammar
      attr_reader :initial_symbol

      def initialize(initial, rules)
        @initial_symbol = initial
        @rules = rules.group_by &:left_symbol
      end

      def rules
        @rules.values.flatten
      end

      def rules_for(symbol)
        @rules.fetch(symbol, [])
      end

      def non_terminal_symbols
        symbols.select(&:non_terminal?)
      end

      def terminal_symbols
        symbols.select(&:terminal?)
      end

      def symbols
        if @symbols then @symbols else
          rules = @rules.values.flatten
          @symbols = (rules.map(&:left_symbol) + rules.map(&:right_symbols).flatten).uniq
        end
      end

      def inspect
        indent = ' ' * 2
        rules = @rules.values.flatten
        lh_width = rules.map { |r| r.left_symbol.to_s.length }.max

        "Grammar\n" +
        "  Non Terminal: #{non_terminal_symbols.join(' ')}\n" +
        "  Terminal: #{terminal_symbols.join(' ')}\n" +
        "  Initial: #{@initial_symbol}\n" +
        "  Rules:\n" + rules.map { |r| indent*2 + r.inspect(lh_width) }.join("\n")
      end

      #def accepts?(str)
      #  Parser.new(self, str).parse
      #end

      #def initial_rule
      #  Rule.new(
      #    Symbol::NonTerminal.new(:"0"),
      #    [Node.new(@initial_symbol)]
      #  )
      #end
    end
  end
end
