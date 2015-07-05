module Gramz
  module CFG

    # @example
    #
    #   grammar :S do
    #     rule :S => "XX | Y"
    #   end
    #
    grammar :S do
      rule "S -> X X | Y"
      rule "X -> a X b | eps"
      rule "Y -> a Y b | Z"
      rule "Z -> b Z a | eps"
    end

    module DSL
      def grammar(initial, &blk)
        GrammarBuilder.new(initial, &blk).build
      end

      class GrammarBuilder
        include Conversions

        def initialize(initial, &blk)
          @initial = Symbol::NonTerminal.new(initial.to_sym)
          @block = blk
        end

        def build
          @rules = []
          instance_eval(&@block)
          Grammar.new(@initial, @rules)
        end

        def rule(hsh)
          k = hsh.keys.first
          v = hsh[k]
          lh = Symbol::NonTerminal.new(k)
          rh = [v].flatten.map { |s| Symbol(s) }
          @rules << Rule.new(lh, rh)
        end
      end

    end
  end
end
