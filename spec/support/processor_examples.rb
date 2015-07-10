module Gramz
  module CFG
    class Grammar

      RSpec.shared_examples "a processor" do
        # Expect a `processor` variable wrapping an `original` grammar. Process
        # result should be equal to `expected` grammar.

        describe "#process" do
          it "should return self" do
            expect(processor.process).to be processor
          end
        end

        describe "#apply?" do
          it "should return true if processor is effective" do
            expect(processor.apply?).to be true
          end

          it "should return false if processor is not effective" do
            processor = UnreachableRulesProcessor.new(expected)
            expect(processor.apply?).to be false
          end
        end

        describe "#original" do
          it "should return the original grammar" do
            expect(processor.original).to be original
          end
        end

        describe "#result" do
          it "should return the processed grammar" do
            expect(processor.process.result).to eq expected
          end
        end
      end

    end
  end
end
