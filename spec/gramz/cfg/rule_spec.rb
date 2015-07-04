require 'spec_helper'

module Gramz::CFG
  describe Rule do
    let(:rule) { Rule.new :S, [:SN, :V] }

    describe "#==" do
      it "should return true if rules have same symbols" do
        other = Rule.new :S, [:SN, :V]
        expect(rule == other).to be true
      end

      it "should return false if different left hand symbol" do
        other = Rule.new :X, [:SN, :V]
        expect(rule == other).to be false
      end

      it "should return false if different right hand symbols" do
        other = Rule.new :S, [:N, :V]
        expect(rule == other).to be false
      end
    end

    describe "#hash" do
      it "should be the same if symbols are identical" do
        other = Rule.new :S, [:SN, :V]
        expect(rule.hash).to eq other.hash
      end

      it "should be different if different left hand symbol" do
        other = Rule.new :X, [:SN, :V]
        expect(rule.hash).not_to eq other.hash
      end

      it "should be different if different right hand symbols" do
        other = Rule.new :S, [:N, :V]
        expect(rule.hash).not_to eq other.hash
      end
    end

    describe "#inspect" do
      it "should return a pretty representation of the rule" do
        expect(rule.inspect).to eq "S → SN V"
      end
    end
  end
end
