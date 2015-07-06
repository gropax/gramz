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
            parse_trees = @states.final.map { |s| build_parse_tree(s) }

            ParseResult.new success, parse_trees, @states
          end

          private

            def predict(state, j)
              sym = state.next_symbol
              @grammar.rules_for(sym).each do |r|
                new_state = State.new(r, 0, j)
                @states.enqueue_at(j, new_state)
              end
            end

            def scan(state, j)
              sym = state.next_symbol
              if sym == @symbols[j]
                new_state = state.next_state
                @states.enqueue_at(j+1, new_state)
              end
            end

            def complete(state, j)
              @states.at(state.origin).select { |s|
                s.next_symbol == state.rule.left_symbol
              }.each { |s|
                new_state = s.next_state
                new_state.children << state
                @states.enqueue_at(j, new_state)
              }
            end

            def initial_rule
              Rule.new(Symbol::Start, [@grammar.initial_symbol, Symbol::End])
            end

            def build_parse_tree(state)
              # First remove the Start symbol at the top of the tree
              root = state.children.first
              ParseTree.new build_node(root, @symbols.dup)
            end

            def build_node(state, symbols)
              node = ParseTree::Node.new(state.rule.left_symbol)
              children = state.children.dup

              state.rule.right_symbols.each do |sym|
                child = if sym.terminal?
                  ParseTree::Node.new symbols.shift
                else
                  build_node(children.shift, symbols)
                end
                node.children << child
              end

              node
            end

        end

      end
    end
  end
end
