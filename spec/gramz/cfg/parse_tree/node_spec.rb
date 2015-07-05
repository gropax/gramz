require 'spec_helper'

module Gramz::CFG
  describe ParseTree::Node do
    let(:node) { ParseTree.builder(:S, {NP: 'Jean', V: 'dort'}).root }

    describe "#==" do
      it "should return true if nodes have same value and children" do
        other = ParseTree.builder(:S, {NP: 'Jean', V: 'dort'}).root
        expect(node == other).to be true
      end

      it "should return false if nodes have different values" do
        other = ParseTree.builder(:X, {NP: 'Jean', V: 'dort'}).root
        expect(node == other).to be false
      end

      it "should return false if nodes have different children" do
        other = ParseTree.builder(:S, {NP: 'Jean', V: 'cours'}).root
        expect(node == other).to be false
      end
    end

  end
end
