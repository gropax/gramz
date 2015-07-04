module Gramz
  module CFG
    class Grammar
      class Processor
        attr_reader :original, :result
        def initialize(grammar)
          @original = grammar
          @result = grammar.dup
        end

        def remove_useless_rules
          remove_unreachable_rules
          remove_unproductive_rules
        end

        def remove_unreachable_rules
          # Find all reachable symbols
          tmp = Set.new
          reachable = Set.new << @result.initial_symbol

          while tmp != reachable
            tmp += reachable
            tmp.each do |sym|
              @result.rules_for(sym).each do |r|
                reachable += r.right_symbols
              end
            end
          end

          # @fixme Remove rules for unreachable symbols
          rules = @result.rules_hash
          rules.each_key do |sym|
            rules.delete(sym) unless reachable.include?(sym)
          end

          self
        end

        def remove_unproductive_rules
          # Find all productive symbols
          tmp, productive = Set.new, Set.new

          terms = @result.terms.to_set
          non_terms = @result.non_terms.to_set

          begin
            tmp += productive
            @result.non_terms.each do |sym|
              @result.rules_for(sym).each do |r|
                if r.right_symbols.to_set < (terms + tmp)
                  productive << sym
                end
              end
            end
          end while tmp != productive

          unproductive = non_terms - productive

          # @fixme Remove rules for unproductive symbols
          rules = @result.rules_hash
          rules.each_value do |rs|
            rs.each do |r|
              rs.delete(r) if r.symbols.to_set.intersect?(unproductive)
            end
          end

          self
        end
      end
    end
  end
end
