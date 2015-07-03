module Gramz
  module LFG

    # @example
    #
    #   grammar :S do
    #     # S →  SN       V
    #     #     (↑SUJ)=↓  ↑=↓
    #     #
    #     rule :S do
    #       node :SN { up :SUJ, down }
    #       node :V  { up down }
    #     end
    #
    #     # SN →  Jean
    #     #      (↑NUM)  = sing
    #     #      (↑MODE) = indicatif
    #     #      (↑PERS) = sing
    #     #      (↑PRED) = 'dormir<SUJ>'
    #     #
    #     rule :SN do
    #       node "Jean" do
    #         up :NUM,  :sing
    #         up :MODE, :indicatif
    #         up :PERS,  3
    #         up :PRED, 'dormir<SUJ>'
    #       end
    #     end
    #
    #     # V →  dort
    #     #     (↑NUM)  = sing
    #     #     (↑GENRE) = masc
    #     #     (↑PRED) = 'Jean'
    #     #
    #     rule :V do
    #       node "dort" do
    #         up :NUM,   :sing
    #         up :GENRE, :masc
    #         up :PRED,  'Jean'
    #       end
    #     end
    #   end
    #
    module DSL
      def grammar(initial, &blk)
        GrammarBuilder.new(initial, &blk).build
      end

      class GrammarBuilder
        def initialize(initial, &blk)
          @initial = Symbol::NonTerminal.new(initial.to_sym)
          @block = blk
        end

        def build
          @rules = []
          instance_eval(&@block)
          Grammar.new(@initial, @rules)
        end

        def rule(symbol, &blk)
          @rules << RuleBuilder.new(symbol, &blk).build
        end
      end

      class RuleBuilder
        def initialize(symbol, &blk)
          @symbol = Symbol::NonTerminal.new(symbol.to_sym)
          @block = blk
        end

        def build
          @nodes = []
          instance_eval(&@block)
          Rule.new(@symbol, @nodes)
        end

        def node(symbol, &blk)
          @nodes << NodeBuilder.new(symbol, &blk).build
        end
      end

      class NodeBuilder
        def initialize(symbol, &blk)
          if symbol.is_a? String
            @symbol = Symbol::Terminal.new(symbol.to_sym)
          else
            @symbol = Symbol::NonTerminal.new(symbol.to_sym)
          end
          @block = blk
        end

        def build
          @equations = []
          #instance_eval(&@block)
          Node.new(@symbol, @equations)
        end

        def up(syms, hsh = {})
        end
      end
    end
  end
end
