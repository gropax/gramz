module Gramz
  module CFG
    module Earley
      class Parser

        class Engine
          def initialize(grammar, symbols)
            @grammar = grammar
            @symbols = symbols << Symbol::End
            @states = States.new
          end

          def parse
            initial_state = State.new(initial_rule, 0, 0)
            initial_state.node = ParseTree::Node.new(Symbol::Start)

            @states.enqueue_at(0, initial_state)

            (0..@symbols.length).each do |i|
              @states.at(i).each do |s|
                if s.completed? then complete(s, i) else
                  sym = s.next_symbol
                  sym && sym.non_terminal? ? predict(s, i) : scan(s, i)
                end
              end
            end

            success = !@states.final.empty?
            parse_trees = @states.final.map { |s|
              # Remove the Start symbol at the top of the tree
              root = s.node.children.first
              ParseTree.new root
            }
            #binding.pry

            ParseResult.new success, parse_trees, @states
          end

          private

            def predict(state, j)
              sym = state.next_symbol
              @grammar.rules_for(sym).each do |r|
                new_state = State.new(r, 0, j)

                new_state.node = ParseTree::Node.new(sym, state.node)

                @states.enqueue_at(j, new_state)
              end
            end

            def scan(state, j)
              sym = state.next_symbol
              if sym == @symbols[j]
                new_state = state.next_state

                new_state.node = state.node
                new_state.node.add_child ParseTree::Node.new(sym)

                @states.enqueue_at(j+1, new_state)
              end
            end

            def complete(state, j)
              @states.at(state.origin).select { |s|
                s.next_symbol == state.rule.left_symbol
              }.each { |s|
                new_state = s.next_state

                new_state.node = state.node.parent.dup
                new_state.node.add_child(state.node)

                @states.enqueue_at(j, new_state)
              }
            end

            def initial_rule
              Rule.new(Symbol::Start, [@grammar.initial_symbol, Symbol::End])
            end
        end

      end
    end
  end
end
