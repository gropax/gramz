require 'spec_helper'

module Gramz::CFG
  class Grammar
    describe MetaSymbolsProcessor do
      include DSL

      let(:original) { grammar(:S) { rule "S -> A | B" } }
      let(:expected) { grammar(:S) { rule "S -> A"; rule "S -> B" } }

      let(:processor) { MetaSymbolsProcessor.new(original) }

      it_behaves_like "a processor"

      describe "#expand_meta_symbols" do
        describe "| meta symbol" do
          let(:original) { grammar(:S) { rule "S -> A | B" } }
          let(:expected) { grammar(:S) { rule "S -> A"; rule "S -> B" } }

          it "should separate original into multiple simple rules" do
            gram = processor.expand_meta_symbols.result
            expect(gram).to eq expected
          end
        end

        describe "* meta symbol" do
          let(:original) { grammar(:S) { rule "S -> A B* C" } }
          let(:expected) {
            grammar(:S) {
              rule "S       -> A _B_STAR C"
              rule "_B_STAR -> B _B_STAR"
              rule "_B_STAR -> eps"
            }
          }

          it "should separate original into multiple simple rules" do
            gram = processor.expand_meta_symbols.result
            expect(gram).to eq expected
          end
        end

        describe "+ meta symbol" do
          let(:original) { grammar(:S) { rule "S -> A B+ C" } }
          let(:expected) {
            grammar(:S) {
              rule "S       -> A _B_PLUS C"
              rule "_B_PLUS -> B _B_PLUS"
              rule "_B_PLUS -> B"
            }
          }

          it "should separate original into multiple simple rules" do
            gram = processor.expand_meta_symbols.result
            expect(gram).to eq expected
          end
        end

        describe "() meta symbol" do
          let(:original) { grammar(:S) { rule "S -> A (B) C" } }
          let(:expected) {
            grammar(:S) {
              rule "S       -> A _B_OPT C"
              rule "_B_OPT -> B"
              rule "_B_OPT -> eps"
            }
          }

          it "should separate original into multiple simple rules" do
            gram = processor.expand_meta_symbols.result
            expect(gram).to eq expected
          end
        end
      end

    end
  end
end
