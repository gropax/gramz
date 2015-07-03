require 'spec_helper'

module Gramz
  class CFG::Earley::Parser
    describe States do

      let(:rule) { CFG::Rule.new :S, [:SN, :V, :SP] }

      let(:states) {
        s = States.new
        s.enqueue_at(0, State.new(rule, 0, 0))
        s.enqueue_at(1, State.new(rule, 1, 1))
        s.enqueue_at(1, State.new(rule, 2, 2))
        s
      }

      describe "#inspect" do
        it "should return pretty representation of the state" do
          expect(states.inspect).to eq <<-EOS.strip.gsub(/ {12}/, '')
            States:
              0:  (S → •SN V SP, 0)
              1:  (S → SN •V SP, 1), (S → SN V •SP, 2)
          EOS
        end
      end
    end

  end
end
