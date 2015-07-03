require 'spec_helper'

module Gramz::LFG
  describe Trait do
    let(:trait) { Trait.new(:NUM, AtomicValue.new(1)) }

    describe "#==" do
      it "should return true if names and values are equal" do
        expect(trait).to eq trait.dup
      end

      it "should return false if names and values are different" do
        other = Trait.new(:NUM, AtomicValue.new(2))
        expect(trait).not_to eq other
      end
    end

  end
end
