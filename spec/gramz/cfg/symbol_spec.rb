require 'spec_helper'

module Gramz::CFG
  describe Symbol do
    let(:terminal) { Symbol::Terminal.new :T }
    let(:non_terminal) { Symbol::NonTerminal.new :N }

    describe "#==" do
      it "should return true if other of same kind and symbol are equal" do
        other = Symbol::Terminal.new :T
        expect(terminal == other).to be true
      end

      it "should return false if symbol is different" do
        other = Symbol::Terminal.new :A
        expect(terminal == other).to be false
      end

      it "should return false if type is different" do
        other = Symbol::NonTerminal.new :T
        expect(terminal == other).to be false
      end
    end
  end
end
