module Gramz
  module CFG
    class Grammar
      class Formater
        def initialize(grammar)
          @grammar = grammar
        end

        def format
          indent = ' ' * 2
          lh_width = @grammar.rules.map { |r| r.left_symbol.to_s.length }.max

          "Grammar\n" +
          "  Non Terminal: #{@grammar.non_terms.join(' ')}\n" +
          "  Terminal: #{@grammar.terms.join(' ')}\n" +
          "  Initial: #{@grammar.initial_symbol}\n" +
          "  Rules:\n" + @grammar.rules.map { |r| indent*2 + r.inspect(lh_width) }.join("\n")
        end
      end
    end
  end
end
