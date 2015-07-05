require 'spec_helper'

module Gramz::CFG
  describe Lexer do
    let(:lexer) { Lexer.new }

    describe "#lex" do
      it "should transform the given string into an array of symbols" do
        syms = lexer.lex "My name is Bob"
        expect(syms.map(&:to_sym)).to eq [:My, :name, :is, :Bob]
      end
    end
  end
end
