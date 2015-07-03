require 'gramz/cfg/earley/parser/state'
require 'gramz/cfg/earley/parser/states'

module Gramz
  module CFG
    module Earley
      class Parser
        include Conversions

        def initialize(grammar)
          @grammar = grammar
        end

        def accepts?(input)
          !parse(input).final.empty?
        end

        def parse(input)
          @symbols = chunk_input(input) << Symbol::End
          @states = States.new

          @states.enqueue_at(0, State.new(initial_rule, 0, 0))

          (0..@symbols.length).each do |i|
            @states.at(i).each do |s|
              if s.complete? then complete(s, i) else
                sym = s.next_symbol
                sym && sym.non_terminal? ? predict(s, i) : scan(s, i)
              end
            end
          end

          @states
        end

        private

          def chunk_input(input)
            case input
            when Array
              input.map { |s| Terminal(s) }
            when String
              input.split(/\s+/).map { |s| Symbol::Terminal.new s }
            else
              raise TypeError, "String or array of Symbols expected."
            end
          end

          def predict(state, j)
            @grammar.rules_for(state.next_symbol).each do |r|
              @states.enqueue_at(j, State.new(r, 0, j))
            end
          end

          def scan(state, j)
            if state.next_symbol == @symbols[j]
              @states.enqueue_at(j+1, state.next_state)
            end
          end

          def complete(state, j)
            @states.at(state.origin).select { |s|
              s.next_symbol == state.rule.left_symbol
            }.each { |s|
              @states.enqueue_at(j, s.next_state)
            }
          end

          def initial_rule
            Rule.new(Symbol::Start, [@grammar.initial_symbol, Symbol::End])
          end
      end

    end
  end
end
