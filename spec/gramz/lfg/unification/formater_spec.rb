require 'spec_helper'

module Gramz::LFG
  class Unification
    describe Formater do
      let(:struct1) { TraitStructure.from_hash({CAT: :N, ACCORD: {NUM: :sing}}) }
      let(:struct2) { TraitStructure.from_hash({ACCORD: {GENRE: :masc}}) }
      let(:unification) { Unification.new(struct1, struct2) }

      let(:formater) { Formater.new(unification) }

      describe "#format" do
        it "should return a pretty representation of the unification operation" do
          expected = <<-EOS.gsub(/^ {12}/, '').gsub(/\n*$/, '')
            ┌                  ┐                                ┌                    ┐
            │CAT     N         │     ┌       ┌           ┐┐     │CAT     N           │
            │       ┌         ┐│  U  │ACCORD │GENRE  masc││  =  │       ┌           ┐│
            │ACCORD │NUM  sing││     └       └           ┘┘     │ACCORD │NUM    sing││
            └       └         ┘┘                                │       │GENRE  masc││
                                                                └       └           ┘┘
          EOS
          unification.compute
          expect(formater.format).to eq expected
        end

        it "should display a ? sign if unification not computed" do
          expected = <<-EOS.gsub(/^ {12}/, '').gsub(/\n*$/, '')
            ┌                  ┐                                   
            │CAT     N         │     ┌       ┌           ┐┐        
            │       ┌         ┐│  U  │ACCORD │GENRE  masc││  =  ???
            │ACCORD │NUM  sing││     └       └           ┘┘        
            └       └         ┘┘                                   
          EOS
          expect(formater.format).to eq expected
        end

        it "should display correctly FalseStructures" do
          fs = FalseStructure.new
          formater = Formater.new fs.unify(fs)

          expected = "⊥  U  ⊥  =  ⊥"
          expect(formater.format).to eq expected
        end

        it "should display correctly empty structures" do
          s = TraitStructure.new
          formater = Formater.new s.unify(s)

          expected = "∅  U  ∅  =  ∅"
          expect(formater.format).to eq expected
        end
      end
    end
  end
end
