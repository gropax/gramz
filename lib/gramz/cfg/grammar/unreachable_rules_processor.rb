module Gramz
  module CFG
    class Grammar
      class UnreachableRulesProcessor < Processor
        process :remove_unreachable_rules

        condition :has_unreachable_symbols? do
          !unreachable_symbols.empty?
        end

        def remove_unreachable_rules
          # @fixme Remove rules for unreachable symbols
          rules = @original.rules_hash.dup
          rules.each_key do |sym|
            rules.delete(sym) if unreachable_symbols.include?(sym)
          end

          Grammar.new(@original.initial_symbol, rules.values.flatten)
        end

        def unreachable_symbols
          @unreachable_symbols ||= compute_unreachable_symbols
        end

        private

          def compute_unreachable_symbols
            tmp = Set.new
            reachable = Set.new << @original.initial_symbol

            while tmp != reachable
              tmp += reachable
              tmp.each do |sym|
                @original.rules_for(sym).each do |r|
                  reachable += r.right_symbols
                end
              end
            end

            Set.new(@original.non_terms) - reachable
          end
      end
    end
  end
end
