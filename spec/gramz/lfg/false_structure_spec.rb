require 'spec_helper'

module Gramz::LFG
  describe FalseStructure do
    let(:fstruct) { FalseStructure.new }

    describe "#unify" do
      it "should return a Unification object" do
        expect(fstruct.unify(fstruct)).to be_kind_of(Unification)
      end
    end
  end
end
