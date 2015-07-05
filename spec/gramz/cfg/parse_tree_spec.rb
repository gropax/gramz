require 'spec_helper'

module Gramz::CFG
  describe ParseTree do
    let(:tree) { ParseTree.builder(:S, {NP: 'Jean', V: 'dort'}) }

    describe "#==" do
      it "should return true if nodes have same value and children" do
        other = ParseTree.builder(:S, {NP: 'Jean', V: 'dort'})
        expect(tree == other).to be true
      end

      it "should return false if nodes have different values" do
        other = ParseTree.builder(:X, {NP: 'Jean', V: 'dort'})
        expect(tree == other).to be false
      end

      it "should return false if nodes have different children" do
        other = ParseTree.builder(:S, {NP: 'Jean', V: 'cours'})
        expect(tree == other).to be false
      end
    end

  end
end
