require 'spec_helper'

module Gramz::CFG
  class Grammar
    describe UnproductiveRulesProcessor do
      include DSL

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

      let(:processor) { UnproductiveRulesProcessor.new(original) }

      it_behaves_like "a processor"

      describe "#has_unproductive_symbols?" do
        it "should return true if grammar has unproductive symbols" do
          expect(processor.has_unproductive_symbols?).to be true
        end

        it "should return false if grammar has no unproductive symbols" do
          processor = UnproductiveRulesProcessor.new(expected)
          expect(processor.has_unproductive_symbols?).to be false
        end
      end

      describe "#remove_unproductive_rules" do
        it "should remove unproductive rules from processed grammar" do
          gram = processor.remove_unproductive_rules
          expect(gram).to eq expected
        end
      end
    end
  end
end
