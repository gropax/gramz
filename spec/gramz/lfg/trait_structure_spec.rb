require 'spec_helper'

module Gramz::LFG
  describe TraitStructure do
    let(:struct) { TraitStructure.from_hash({NUM: 1, DET: {NUM: 1}}) }

    describe "#unify" do
      it "should return a Unification object" do
        expect(struct.unify(struct.dup)).to be_kind_of(Unification)
      end
    end

    describe "#==" do
      it "should return true if traits are equal" do
        other = TraitStructure.from_hash({NUM: 1, DET: {NUM: 1}})
        expect(struct).to eq other
      end

      it "should return false if some traits are different" do
        other = TraitStructure.from_hash({NUM: 1, DET: {NUM: 2}})
        expect(struct).not_to eq other
      end

      it "should return false if some traits are absent" do
        other = TraitStructure.from_hash({DET: {NUM: 2}})
        expect(struct).not_to eq other
      end
    end
  end
end
