module Gramz
  module CFG
    class Grammar
      class UnproductiveRulesProcessor < Processor
        process :remove_unproductive_rules

        condition :has_unproductive_symbols? do
          !unproductive_symbols.empty?
        end

        def remove_unproductive_rules
          # @fixme Remove rules for unproductive symbols
          rules = @original.rules_hash.dup
          rules.each_value do |rs|
            rs.each do |r|
              rs.delete(r) if r.symbols.to_set.intersect?(unproductive_symbols)
            end
          end

          Grammar.new(@original.initial_symbol, rules.values.flatten)
        end

        def unproductive_symbols
          @unproductive_symbols ||= compute_unproductive_symbols
        end

        private

          def compute_unproductive_symbols
            tmp, productive = Set.new, Set.new

            terms = @original.terms.to_set
            non_terms = @original.non_terms.to_set

            begin
              tmp += productive
              @original.non_terms.each do |sym|
                @original.rules_for(sym).each do |r|
                  if r.right_symbols.to_set <= (terms + tmp)
                    productive << sym
                  end
                end
              end
            end while tmp != productive

            non_terms - productive
          end
      end
    end
  end
end
