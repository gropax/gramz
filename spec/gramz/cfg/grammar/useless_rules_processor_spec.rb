require 'spec_helper'

module Gramz::CFG
  class Grammar
    describe UselessRulesProcessor do
      include DSL

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

      let(:processor) { UselessRulesProcessor.new(original) }

      it_behaves_like "a processor"

      describe "#has_useless_symbols?" do
        it "should return true if grammar has useless symbols" do
          expect(processor.has_useless_symbols?).to be true
        end

        it "should return false if grammar has no useless symbols" do
          processor = UselessRulesProcessor.new(expected)
          expect(processor.has_useless_symbols?).to be false
        end
      end

      describe "#remove_useless_rules" do
        it "should remove useless rules from processed grammar" do
          gram = processor.remove_useless_rules
          expect(gram).to eq expected
        end
      end
    end
  end
end
