require 'spec_helper'

module Gramz::CFG
  describe DSL do
    include DSL

    describe "#rule" do
      let(:rule) { gram.rules.first }

      describe "simple rule" do
        let(:gram) {
          grammar(:S) { rule "S -> Pro V chien 'Jean'" }
        }
        it "should generate a well formed rule" do
          expect(rule.left_symbol.value).to eq :S
          syms = rule.right_symbols.map(&:value)
          expect(syms).to match_array [:Pro, :V, :chien, :Jean]
        end

        it "should detect if symbols are terms or non terms" do
          pro, v, chien, jean = rule.right_symbols

          expect(pro).to be_non_terminal
          expect(v).to be_non_terminal
          expect(chien).to be_terminal
          expect(jean).to be_terminal
        end
      end

      describe "epsilon symbol" do
        let(:gram) {
          grammar(:S) { rule "S -> A eps B" }
        }
        it "should detect epsilon symbol" do
          rside = rule.right_symbols
          expect(rside[1]).to be Symbol::Epsilon
        end
      end

      describe "| meta symbol" do
        let(:gram) {
          grammar(:S) { rule "S -> A 'Jean' | chien Pro" }
        }
        it "should define multiple rule alternative" do
          rside = rule.right_symbols

          expect(rside.size).to be 1
          alts = rside.first
          expect(alts).to be_kind_of Rule::Alternative
          expect(alts[0].map(&:value)).to match_array [:A, :Jean]
          expect(alts[1].map(&:value)).to match_array [:chien, :Pro]
        end
      end

      describe "* meta symbol" do
        let(:gram) {
          grammar(:S) { rule "S -> A B* C" }
        }
        it "should define a kleene star symbol" do
          a, b, c = rule.right_symbols
          expect(b).to be_kind_of Rule::KleeneStar
          expect(b.symbol.value).to be :B
        end
      end

      describe "+ meta symbol" do
        let(:gram) {
          grammar(:S) { rule "S -> A B+ C" }
        }
        it "should define a kleene plus symbol" do
          a, b, c = rule.right_symbols
          expect(b).to be_kind_of Rule::KleenePlus
          expect(b.symbol.value).to be :B
        end
      end

      describe "() meta symbol" do
        let(:gram) {
          grammar(:S) { rule "S -> A (B) C" }
        }
        it "should define an optional symbol" do
          a, b, c = rule.right_symbols
          expect(b).to be_kind_of Rule::Optional
          expect(b.symbol.value).to be :B
        end
      end
    end

  end
end
