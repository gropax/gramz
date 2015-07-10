require 'spec_helper'

module Gramz::CFG
  class Grammar
    describe UnreachableRulesProcessor do
      include DSL

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

      let(:processor) { UnreachableRulesProcessor.new(original) }

      it_behaves_like "a processor"

      describe "#has_unreachable_symbols?" do
        it "should return true if grammar has unreachable symbols" do
          expect(processor.has_unreachable_symbols?).to be true
        end

        it "should return false if grammar has no unreachable symbols" do
          processor = UnreachableRulesProcessor.new(expected)
          expect(processor.has_unreachable_symbols?).to be false
        end
      end

      describe "#remove_unreachable_rules" do
        it "should remove unreachable rules from processed grammar" do
          gram = processor.remove_unreachable_rules
          expect(gram).to eq expected
        end
      end
    end
  end
end
