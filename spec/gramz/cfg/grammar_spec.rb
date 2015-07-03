require 'spec_helper'

module Gramz::CFG
  describe Grammar do
    include Gramz::CFG::DSL

    let(:my_grammar) {
      grammar :S,
        :S  => [:SN, :V],
        :SN => "Jean",
        :V  => "dort"
    }

    describe "#non_terminal_symbols" do
      it "should return the non terminal symbols used in rules" do
        expect(my_grammar.non_terminal_symbols.map(&:to_sym)).to match_array [:S, :SN, :V]
      end
    end

    describe "#terminal_symbols" do
      it "should return the terminal symbols used in rules" do
        expect(my_grammar.terminal_symbols.map(&:to_sym)).to match_array [:Jean, :dort]
      end
    end

    describe "#inspect" do
      it "should return a pretty representation of the grammar" do
        expect(my_grammar.inspect).to eq <<-EOS.strip.gsub(/ {10}/, '')
          Grammar
            Non Terminal: S SN V
            Terminal: Jean dort
            Initial: S
            Rules:
              S  → SN V
              SN → Jean
              V  → dort
        EOS
      end
    end
  end
end
