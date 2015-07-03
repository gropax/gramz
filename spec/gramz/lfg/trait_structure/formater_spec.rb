require 'spec_helper'

module Gramz::LFG
  class TraitStructure
    describe Formater do
      let(:struct) {
        TraitStructure.from_hash({
          SUJ: {
            PRED: 'Jean',
            GENRE: :masc,
            NUM: :sing
          },
          PRED: 'ressembler⟨SUJ,À-OBJ⟩',
          MODE: :indicatif,
          :"À-OBJ" => {
            PCAS: :"À-OBJ",
            PRED: 'Paul',
            GENRE: :masc,
            NUM: :sing
          }
        })
      }
      let(:formater) { Formater.new(struct) }

      describe "#format" do
        it "should return a pretty representation of the structure" do
          expected = <<-EOS.strip.gsub(/^ {12}/, '')
            ┌      ┌            ┐         ┐
            │      │PRED  'Jean'│         │
            │SUJ   │GENRE  masc │         │
            │      │NUM    sing │         │
            │      └            ┘         │
            │PRED  'ressembler⟨SUJ,À-OBJ⟩'│
            │MODE   indicatif             │
            │      ┌            ┐         │
            │      │PCAS   À-OBJ│         │
            │À-OBJ │PRED  'Paul'│         │
            │      │GENRE  masc │         │
            │      │NUM    sing │         │
            └      └            ┘         ┘
          EOS
          expect(formater.format).to eq expected
        end

        it "should display correctly false structures" do
          formater = Formater.new(FalseStructure.new)
          expect(formater.format).to eq "⊥"
        end

        it "should display correctly empty structures" do
          formater = Formater.new(TraitStructure.new)
          expect(formater.format).to eq "∅"
        end
      end
    end
  end
end
