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

        def expand_meta_symbols
          rules, meta = [], Set.new

          # Replace meta symbol by new non terms in existing rules
          @original.rules.each_with_object(meta) do |r, meta|
            rsyms = r.right_symbols.map do |s|
              if !meta_symbol?(s) then s else
                meta << s
                Symbol::NonTerminal.new rename_meta_symbol s
              end
            end
            rules << Rule.new(r.left_symbol, rsyms)
          end

          meta.each do |sym|
            rule
          end
        end

        def expand_meta_symbols
          rules = expand_alternatives(@original.rules)
          rules = expand_modifier_symbols(rules)

          @result = Grammar.new(@original.initial_symbol, rules)

          self
        end

        private

          def expand_alternatives(rules)
            rules.map { |r|
              if !alternative?(r) then r else
                alts = r.right_symbols.first
                alts.map { |alt| Rule.new(r.left_symbol, alt) }
              end
            }.flatten
          end

          def expand_modifier_symbols(rules)
            meta = Set.new

            modified = rules.map { |r|
              rsyms = r.right_symbols.map { |s|
                if !meta_symbol?(s) then s else
                  meta << s
                  Symbol::NonTerminal.new rename_meta_symbol s
                end
              }
              Rule.new(r.left_symbol, rsyms)
            }

            added = meta.map { |s| build_meta_rule(s) }.flatten

            modified + added
          end

          def build_meta_rule(meta)
            case meta
            when Rule::KleeneStar
              lsym = Symbol::NonTerminal.new(rename_meta_symbol meta)
              [Rule.new(lsym, [meta.symbol, lsym]), Rule.new(lsym, [Symbol::Epsilon])]
            when Rule::KleenePlus
              lsym = Symbol::NonTerminal.new(rename_meta_symbol meta)
              [Rule.new(lsym, [meta.symbol, lsym]), Rule.new(lsym, [meta.symbol])]
            when Rule::Optional
              lsym = Symbol::NonTerminal.new(rename_meta_symbol meta)
              [Rule.new(lsym, [meta.symbol]), Rule.new(lsym, [Symbol::Epsilon])]
            else
              raise TypeError, "Unknown meta symbol type #{meta.class}"
            end
          end

          def alternative?(rule)
            rsyms = rule.right_symbols
            rsyms.size == 1 && rsyms.first.is_a?(Rule::Alternative)
          end

          def meta_symbol?(sym)
            sym.is_a?(Rule::MetaSymbol)
          end

          def rename_meta_symbol(meta)
            case meta
            when Rule::KleeneStar then :"_#{meta.symbol}_STAR"
            when Rule::KleenePlus then :"_#{meta.symbol}_PLUS"
            when Rule::Optional then :"_#{meta.symbol}_OPT"
            else
              raise TypeError, "Unknown meta symbol type #{meta.class}"
            end
          end
      end
    end
  end
end
