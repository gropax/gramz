require 'spec_helper'

module Gramz::CFG
  describe Rule do
    let(:rule) { Rule.new :S, [:SN, :V] }

    describe "#inspect" do
      it "should return a pretty representation of the rule" do
        expect(rule.inspect).to eq "S → SN V"
      end
    end
  end
end
