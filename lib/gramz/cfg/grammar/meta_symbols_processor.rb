module Gramz
  module CFG
    class Grammar
      class MetaSymbolsProcessor < Processor
        process :expand_meta_symbols
        condition :has_meta_symbols?

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
