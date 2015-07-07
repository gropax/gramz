module Gramz
  module CFG

    # @example
    #
    #   grammar :S do
    #     rule :S => "XX | Y"
    #   end
    #
    #grammar :S do
    #  rule "S -> X* | Y"
    #  rule "X -> a X b | eps"
    #  rule "Y -> a Y b | Z"
    #  rule "Z -> b Z a | eps"
    #end

    module DSL
      DSLError = Class.new StandardError

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

        def rule(str)
          lside, rside = str.strip.split(/\s*->\s*/)
          lsym = Symbol::NonTerminal.new lside.to_sym
          rsyms = build_right_side(lsym, rside)

          @rules << Rule.new(lsym, rsyms)
        end

        def build_right_side(lsym, str)
          if str.include? '|'
            alts = str.split(/\s*\|\s*/).map { |a| build_right_side lsym, a }
            [] << Rule::Alternative.new(lsym, alts)
          else
            str.split(/\s+/).map { |str| build_symbol str }
          end
        end

        def build_symbol(str)
          case str
          when 'eps'
            Symbol::Epsilon
          when /^(\w+)\*$/
            Rule::KleeneStar.new build_symbol $1
          when /^(\w+)\+$/
            Rule::KleenePlus.new build_symbol $1
          when /^\((\w+)\)$/
            Rule::Optional.new build_symbol $1
          when /^_?[A-Z]/
            Symbol::NonTerminal.new str.to_sym
          when /^'(\w+)'$/, /^([a-z]+)$/
            Symbol::Terminal.new $1.to_sym
          else
            raise DSLError, "Malformed rule symbol: `#{str}`"
          end
        end
      end

    end
  end
end
