require 'spec_helper'

module Gramz
  class CFG::Earley::Parser
    describe State do

      let(:rule) { CFG::Rule.new :S, [:SN, :V, :SP] }
      let(:state) { State.new(rule, 1, 3) }

      describe "#inspect" do
        it "should return pretty representation of the state" do
          expect(state.inspect).to eq "(S → SN •V SP, 3)"
        end

        it "should put dot at the end when last symbol processed" do
          state = State.new(rule, 3, 3)
          expect(state.inspect).to eq "(S → SN V SP•, 3)"
        end
      end

      describe "#==" do
        it "should return true if states have same rule, current and origin" do
          other = State.new(rule, 1, 3)
          expect(state == other).to be true
        end

        it "should return false if states DOESN'T have same rule, current or origin" do
          other = State.new(rule, 2, 3)
          expect(state == other).to be false
        end
      end

      describe "#hash" do
        it "should be shared by equal states" do
          other = State.new(rule, 1, 3)
          expect(state.hash).to be other.hash
        end

        it "should NOT be shared by different states" do
          other = State.new(rule, 1, 2)
          expect(state.hash).not_to be other.hash
        end
      end

    end
  end
end
