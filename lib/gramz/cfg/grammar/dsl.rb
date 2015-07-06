module Gramz
  module CFG

    # @example
    #
    #   grammar :S do
    #     rule :S  => [:SN, :V]
    #     rule :SN => "Jean"
    #     rule :V  => "dort
    #   end
    #
    module DSL
      def grammar(initial, &blk)
        gram = GrammarBuilder.new(initial, &blk).build
        if ENV["GRAMZ"]
          # Store grammar if global var if run from gramz cli
          $gramz_grammar = gram
        else
          gram
        end
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
