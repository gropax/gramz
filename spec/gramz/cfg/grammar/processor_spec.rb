require 'spec_helper'

module Gramz::CFG
  class Grammar
    describe Processor do
      include DSL

      let(:original) {
        grammar(:S) {
          rule "S  ->  SN V"
          rule "SN -> 'Jean'"
          rule "V  ->  dort"
        }
      }

      let(:processor) { Processor.new(original) }

      describe "#original" do
        it "should return the original grammar" do
          expect(processor.original).to be original
        end
      end

      describe "#result" do
        it "should return the processed grammar" do
          expect(processor.result).to eq original # Return clone of original if no process
          expect(processor.result).not_to be original
        end
      end

      describe "#remove_useless_rules" do
        let :original do
          grammar(:S) {
            rule "S -> A a"
            rule "A -> A a"
            rule "A -> a"
            # Symbol X is unreachable
            rule "X -> x"
            # Symbol E is unproductive
            rule "S -> E e"
            rule "E -> E e"
          }
        end

        let :expected do
          grammar(:S) {
            rule "S -> A a"
            rule "A -> A a"
            rule "A -> a"
          }
        end

        it "should return self" do
          expect(processor.remove_useless_rules).to be processor
        end

        it "should remove unreachable and unproductive rules" do
          gram = processor.remove_useless_rules.result
          expect(gram).to eq expected
        end
      end

      describe "#remove_unreachable_rules" do
        let :original do
          grammar(:S) {
            rule "S  -> SN V"
            rule "X  -> SN 'Bougle'" # Unreachable
            rule "SN -> 'Jean'"
            rule "V  ->  dort"
          }
        end

        let :expected do
          grammar(:S) {
            rule "S  ->  SN V"
            rule "SN -> 'Jean'"
            rule "V  ->  dort"
          }
        end

        it "should return self" do
          expect(processor.remove_unreachable_rules).to be processor
        end

        it "should remove unreachable rules from processed grammar" do
          gram = processor.remove_unreachable_rules.result
          expect(gram).to eq expected
        end
      end

      describe "#remove_unproductive_rules" do
        let :original do
          grammar(:S) {
            rule "S -> A a"
            rule "A -> A a"
            rule "A -> a"
            # Symbol E is unproductive
            rule "S -> E e"
            rule "E -> E e"
          }
        end

        let :expected do
          grammar(:S) {
            rule "S -> A a"
            rule "A -> A a"
            rule "A -> a"
          }
        end

        it "should return self" do
          expect(processor.remove_unproductive_rules).to be processor
        end

        it "should remove unreachable rules from processed grammar" do
          gram = processor.remove_unproductive_rules.result
          expect(gram).to eq expected
        end
      end

      describe "#expand_meta_symbols" do
        describe "| meta symbol" do
          let(:original) { grammar(:S) { rule "S -> A | B" } }
          let(:expected) { grammar(:S) { rule "S -> A"; rule "S -> B" } }

          it "should return self" do
            expect(processor.expand_meta_symbols).to be processor
          end

          it "should separate original into multiple simple rules" do
            gram = processor.expand_meta_symbols.result
            expect(gram).to eq expected
          end
        end

        describe "* meta symbol" do
          let(:original) { grammar(:S) { rule "S -> A B* C" } }
          let(:expected) {
            grammar(:S) {
              rule "S       -> A _B_STAR C"
              rule "_B_STAR -> B _B_STAR"
              rule "_B_STAR -> eps"
            }
          }

          it "should return self" do
            expect(processor.expand_meta_symbols).to be processor
          end

          it "should separate original into multiple simple rules" do
            gram = processor.expand_meta_symbols.result
            expect(gram).to eq expected
          end
        end

        describe "+ meta symbol" do
          let(:original) { grammar(:S) { rule "S -> A B+ C" } }
          let(:expected) {
            grammar(:S) {
              rule "S       -> A _B_PLUS C"
              rule "_B_PLUS -> B _B_PLUS"
              rule "_B_PLUS -> B"
            }
          }

          it "should return self" do
            expect(processor.expand_meta_symbols).to be processor
          end

          it "should separate original into multiple simple rules" do
            gram = processor.expand_meta_symbols.result
            expect(gram).to eq expected
          end
        end

        describe "() meta symbol" do
          let(:original) { grammar(:S) { rule "S -> A (B) C" } }
          let(:expected) {
            grammar(:S) {
              rule "S       -> A _B_OPT C"
              rule "_B_OPT -> B"
              rule "_B_OPT -> eps"
            }
          }

          it "should return self" do
            expect(processor.expand_meta_symbols).to be processor
          end

          it "should separate original into multiple simple rules" do
            gram = processor.expand_meta_symbols.result
            expect(gram).to eq expected
          end
        end
      end

      describe "#remove_epsilon_rules" do
        let :original do
          grammar(:S) {
            rule "S -> A a"
            rule "A -> A a"
            rule "A -> a"
          }
        end

        let :expected do
          grammar(:S) {
            rule "S -> A a"
            rule "A -> A a"
            rule "A -> a"
          }
        end

        it "should return self" do
          expect(processor.remove_epsilon_rules).to be processor
        end

        it "should remove unreachable rules from processed grammar" do
          gram = processor.remove_epsilon_rules.result
          expect(gram).to eq expected
        end
      end
    end
  end
end
