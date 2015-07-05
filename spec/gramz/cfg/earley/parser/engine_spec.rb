require 'spec_helper'

module Gramz::CFG
  class Earley::Parser
    describe Engine do
      include DSL

      let(:my_grammar) {
        grammar :S do
          rule :S  => [:NP, :VP]
          rule :NP => ['art', 'adj', 'n']
          rule :NP => ['art', 'n']
          rule :NP => ['adj', 'n']
          rule :VP => ['aux', :VP]
          rule :VP => ['v', :NP]
        end
      }

      let(:input) { Lexer.new.lex(input_str) }
      let(:engine) { Engine.new(my_grammar, input) }

      describe "#parse" do
        context "when valid input" do
          let(:input_str) { "art adj n aux v art n" }

          it "should return successful result" do
            expect(engine.parse).to be_accepted
          end
        end

        context "when invalid input" do
          let(:input_str) { "art adj n aux n art n" }

          it "should return failure result" do
            expect(engine.parse).to be_rejected
          end
        end

        context "when has trailing symbols" do
          let(:input_str) { "art adj n aux v art n glop" }

          it "should return failure result" do
            expect(engine.parse).to be_rejected
          end
        end
      end

    end
  end
end
