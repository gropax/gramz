require 'spec_helper'

module Gramz::LFG
  describe AtomicValue do
    let(:value) { AtomicValue.new 1 }

    describe "#==" do
      it "should return true if atoms are equal"
      it "should return false if atoms are not equal"
    end

    describe "#inspect" do
      it "should return a pretty representation" do
        expect(value.inspect).to eq "1"
      end
    end
  end
end
