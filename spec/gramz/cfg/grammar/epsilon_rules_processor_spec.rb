require 'spec_helper'

module Gramz::CFG
  class Grammar
    describe EpsilonRulesProcessor do
      include DSL

      let(:with_eps) {
        grammar(:S) {
          rule "S -> A B C"
          rule "A -> a A"
          rule "A -> eps"
          rule "B -> b"
          rule "C -> A"
        }
      }

      let(:without_eps) {
        grammar(:S) {
          rule "S -> A B C"
          rule "S -> A B"
          rule "S -> B C"
          rule "S -> B"
          rule "A -> a"
          rule "A -> a A"
          rule "B -> b"
          rule "C -> A"
        }
      }

      let(:processor) { EpsilonRulesProcessor.new(with_eps) }

      describe "#has_epsilon_rules?" do
        it "should return true if grammar has epsilon rules" do
          expect(processor.has_epsilon_rules?).to be true
        end

        it "should return true if grammar has epsilon rules" do
          processor = EpsilonRulesProcessor.new(without_eps)
          expect(processor.has_epsilon_rules?).to be false
        end
      end

      describe "#nullable_symbols" do
        it "should return the list of nullable symbols if some" do
          syms = processor.nullable_symbols.map &:to_sym
          expect(syms).to eq [:A, :C]
        end

        it "should return the empty array if not" do
          processor = EpsilonRulesProcessor.new(without_eps)
          expect(processor.nullable_symbols).to eq []
        end
      end

      describe "#remove_epsilon_rules" do
        it "should remove epsilon rules from processed grammar" do
          gram = processor.remove_epsilon_rules
          expect(gram).to eq without_eps
        end

        context "when initial symbol is nullable" do
          let(:with_eps) {
            grammar(:S) {
              rule "S -> a S"
              rule "S -> eps"
            }
          }
          let(:without_eps) {
            grammar(:S) {
              rule "_S0 -> S"
              rule "_S0 -> eps"
              rule "S   -> a S"
              rule "S   -> a"
            }
          }

          it "should create a new initial symbol" do
            gram = processor.remove_epsilon_rules
            expect(gram).to eq without_eps
          end
        end
      end

      describe "#create_initial_symbol" do
        it "should return a new special symbol from normal one" do
          old = Symbol::NonTerminal.new('S')
          new = processor.send(:create_initial_symbol, old)

          expect(new.internal).to be :"_S0"
        end

        it "should increment the symbol if special symbol" do
          old = Symbol::NonTerminal.new('_S0')
          new = processor.send(:create_initial_symbol, old)

          expect(new.internal).to be :"_S1"
        end
      end
    end
  end
end
