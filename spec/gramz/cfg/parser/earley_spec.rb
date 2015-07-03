require 'spec_helper'

module Gramz
  module CFG::Earley
    describe Parser do
      include CFG::DSL

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

      let(:parser) { Parser.new(my_grammar) }

      describe "#accepts?" do
        it "should return true if input accepted by grammar" do
          s = [:art, :adj, :n, :aux, :v, :art, :n]
          expect(parser.accepts? s).to be true
        end

        it "should return false if input NOT accepted by grammar" do
          s = [:art, :adj, :n, :aux, :n, :art, :n]
          expect(parser.accepts? s).to be false
        end

        it "should return false if input has trailing symbols" do
          s = [:art, :adj, :n, :aux, :v, :art, :n, :too_much]
          expect(parser.accepts? s).to be false
        end
      end

    end
  end
end
