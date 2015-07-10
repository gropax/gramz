module Gramz
  module CFG
    class Grammar
      class EpsilonRulesProcessor < Processor
        process :remove_epsilon_rules
        condition :has_epsilon_rules?

        def has_epsilon_rules?
          !nullable_symbols.empty?
        end

        def remove_epsilon_rules
          old_i = @original.initial_symbol
          new_i, added = old_i, []

          # Add a new initial symbol if current one is nullable
          if nullable_symbols.include? old_i
            new_i = create_initial_symbol old_i
            added << Rule.new(new_i, [@original.initial_symbol])
            added << Rule.new(new_i, [Symbol::Epsilon])
          end

          modified = @original.rules.select { |r| !r.epsilon_rule? }.map { |r|

            # Build nullable symbols combinations
            combi = [[]]
            r.right_symbols.each { |sym|
              if nullable_symbols.include?(sym)
                combi = combi + combi.map { |syms| syms.dup << sym }
              else
                combi.map! { |syms| syms << sym }
              end
            }
            # Exclude the case where right side is epsilon
            combi.delete []

            # Create a new rule for each combination
            combi.map { |syms| Rule.new(r.left_symbol, syms) }

          }.flatten

          Grammar.new(new_i, added + modified)
        end

        def nullable_symbols
          @nullable_symbols ||= compute_nullable_symbols
        end

        private

          def compute_nullable_symbols
            null, tmp = Set.new, Set.new
            begin
              tmp += null
              @original.non_terms.each do |sym|
                @original.rules_for(sym).each { |r|
                  if r.epsilon_rule? || r.right_symbols.all? { |s| null.include?(s) }
                    null << sym
                  end
                }
              end
            end while tmp != null

            null.to_a
          end

          # Return a new non terminal symbol which name is derived from the
          # given one if the following fashion:
          #     S ~> _S0
          #   _S0 ~> _S1
          #
          def create_initial_symbol(sym)
            m = sym.internal.to_s.match /^_?([_A-Z]+)(\d+)?/
            s = $1.to_s
            i = $2 ? $2.to_i.succ.to_s : '0'
            name = "_" + s + i
            Symbol::NonTerminal.new(name)
          end
      end
    end
  end
end
