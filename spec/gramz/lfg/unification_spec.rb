require 'spec_helper'

module Gramz::LFG
  describe Unification do
    let(:struct1) { TraitStructure.from_hash({CAT: :N, ACCORD: {NUM: :sing}}) }
    let(:struct2) { TraitStructure.from_hash({ACCORD: {GENRE: :masc}}) }
    let(:struct3) { TraitStructure.from_hash({CAT: :N, ACCORD: {NUM: :sing, GENRE: :masc}}) }

    let(:unification) { Unification.new(struct1, struct2) }

    describe "#compute" do
      it "should return self" do
        expect(unification.compute).to be unification
      end

      it "should compute the unification and memorize the result" do
        expected = TraitStructure.from_hash({CAT: :N, ACCORD: {NUM: :sing, GENRE: :masc}})
        unification.compute

        expect(unification.result).to eq expected
      end
    end

    describe "#result" do
      it "should raise error if operation has not been computed" do
        expect { unification.result }.to raise_error(Unification::UnificationError)
      end
    end

    describe "unification computation" do
      describe "#unify_atomic_values" do
        let(:atom) { AtomicValue.new :masc }

        it "should return an atomic value if unification succeeds" do
          ret = unification.send(:unify_atomic_values, atom, atom.dup)
          expect(ret).to eq atom
        end

        it "should return a FalseStructure if unification fails" do
          other = AtomicValue.new :fem
          ret = unification.send(:unify_atomic_values, atom, other)
          expect(ret).to be_kind_of(FalseStructure)
        end
      end

      describe "#unify_traits" do
        let(:trait) { Trait.new :GENDER, AtomicValue.new(:masc) }

        it "should return an trait if unification succeeds" do
          ret = unification.send(:unify_traits, trait, trait.dup)
          expect(ret.name).to eq :GENDER
          expect(ret.value.atom).to eq :masc
        end

        it "should return nil if unification fails" do
          other = Trait.new :GENDER, AtomicValue.new(:fem)
          ret = unification.send(:unify_traits, trait, other)
          expect(ret).to be_nil
        end
      end

      describe "#unify_trait_structures" do
        it "should return an trait if unification succeeds" do
          ret = unification.send(:unify_trait_structures, struct1, struct2)
          expect(ret).to eq struct3
        end

        it "should return a FalseStructure if unification fails" do
          other = TraitStructure.from_hash({CAT: :V, ACCORD: {NUM: :sing}})
          ret = unification.send(:unify_trait_structures, struct1, other)
          expect(ret).to be_kind_of FalseStructure
        end
      end
    end


  end
end
