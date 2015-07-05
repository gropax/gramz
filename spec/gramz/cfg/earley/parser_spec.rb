require 'spec_helper'

module Gramz
  module CFG
    describe Earley::Parser do
      include CFG::DSL

      let(:my_grammar) {
        grammar :S do
          rule :S  => [:NP, :VP]
          rule :NP => [:D, :N]
          rule :D  => 'Le'
          rule :D  => 'une'
          rule :N  => 'chat'
          rule :N  => 'souris'
          rule :VP => [:V, :NP]
          rule :V  => 'mange'
        end
      }

      let(:parser) { Earley::Parser.new(my_grammar) }

      describe "#parse" do
        it "should return a ParseResult object" do
          expect(parser.parse "whatever").to be_kind_of ParseResult
        end

        context "when valid sentence" do
          before :each do
            s = "Le chat mange une souris"
            @result = parser.parse s
          end

          it "should accept the sentence" do
            expect(@result).to be_accepted
          end

          let(:tree) {
            ParseTree.builder(:S, {
              NP: {D: 'Le', N: 'chat'},
              VP: {
                V: 'mange',
                NP: {D: 'une', N: 'souris'}
              }
            })
          }

          it "should generate a list of possible parse trees" do
            expect(@result.parse_trees.size).to eq 1
            expect(@result.parse_trees.first).to eq tree
          end
        end

        context "when invalid sentence" do
          it "should reject the sentence" do
            s = "Le chat une souris mange"
            expect(parser.parse s).to be_rejected
          end
        end
      end

    end
  end
end
