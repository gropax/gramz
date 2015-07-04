require 'spec_helper'

module Gramz::CFG
  describe Grammar do
    include DSL

    let(:gram) {
      grammar :S do
        rule :S  => [:SN, :V]
        rule :SN => "Jean"
        rule :V  => "dort"
      end
    }

    describe "#non_terms" do
      it "should return the non terminal symbols used in rules" do
        expect(gram.non_terms.map(&:to_sym)).to match_array [:S, :SN, :V]
      end
    end

    describe "#terms" do
      it "should return the terminal symbols used in rules" do
        expect(gram.terms.map(&:to_sym)).to match_array [:Jean, :dort]
      end
    end

    describe "#==" do
      it "should return true if grammars have same rules whatever their order" do
        other = grammar :S do
          rule :S  => [:SN, :V]
          rule :V  => "dort"
          rule :SN => "Jean"
        end
        expect(gram == other).to be true
      end

      it "should return false if grammars have different rules" do
        other = grammar :S do
          rule :S  => [:V, :SN]
          rule :V  => "dort"
          rule :SN => "Jean"
        end
        expect(gram == other).to be false
      end
    end

    describe "#dup" do
      it "should return a copy of self" do
        expect(gram.dup).to eq gram
        expect(gram.dup).not_to be gram
      end

      it "should also duplicate the @rules instance variable" do
        hsh = gram.dup.send :rules_hash
        expect(hsh).to eq gram.send :rules_hash
        expect(hsh).not_to be gram.send :rules_hash
      end
    end

    describe "#format" do
      it "should return a string representation of self" do
        expect(gram.format).to be_kind_of String
      end
    end
  end
end
