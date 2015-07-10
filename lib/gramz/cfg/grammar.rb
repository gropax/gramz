require_relative 'grammar/formater'
require_relative 'grammar/processor'
require_relative 'grammar/composite_processor'
require_relative 'grammar/meta_symbols_processor'
require_relative 'grammar/unreachable_rules_processor'
require_relative 'grammar/unproductive_rules_processor'
require_relative 'grammar/useless_rules_processor'
require_relative 'grammar/epsilon_rules_processor'

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

      def non_terms
        symbols.select(&:non_terminal?)
      end

      def terms
        symbols.select(&:terminal?)
      end

      def symbols
        if @symbols then @symbols else
          rules = @rules.values.flatten
          @symbols = (rules.map(&:left_symbol) + rules.map(&:right_symbols).flatten).uniq
        end
      end

      def ==(other)
        Set.new(self.rules) == Set.new(other.rules)
      end

      # Return a copy of self. Duplicate the `@rules` variable in order to
      # modify grammars' rules independently.
      #
      def dup
        self.class.new(@initial_symbol, self.rules)
      end

      def format(formater = Formater)
        formater.new(self).format
      end

      def inspect
        format
      end

      def rules_hash
        @rules
      end
    end
  end
end
