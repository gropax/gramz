require 'spec_helper'

module Gramz::CFG
  class Grammar
    describe Processor do
      include DSL

      let :original do
        grammar :S do
          rule :S  => [:SN, :V]
          rule :SN => "Jean"
          rule :V  => "dort"
        end
      end

      let(:processor) { Processor.new(original) }

      describe "#original" do
        it "should return the original grammar" do
          expect(processor.original).to be original
        end
      end

      describe "#result" do
        it "should return the processed grammar" do
          expect(processor.result).to eq original # Return clone of original if no process
          expect(processor.result).not_to be original
        end
      end

      describe "#remove_useless_rules" do
        let :original do
          grammar :S do
            rule :S  => [:A, 'a']
            rule :A  => [:A, 'a']
            rule :A  => 'a'
            # Symbol X is unreachable
            rule :X  => 'x'
            # Symbol E is unproductive
            rule :S  => [:E, 'e']
            rule :E  => [:E, 'e']
          end
        end

        let :expected do
          grammar :S do
            rule :S  => [:A, 'a']
            rule :A  => [:A, 'a']
            rule :A  => 'a'
          end
        end

        it "should return self" do
          expect(processor.remove_useless_rules).to be processor
        end

        it "should remove unreachable and unproductive rules" do
          gram = processor.remove_useless_rules.result
          expect(gram).to eq expected
        end
      end

      describe "#remove_unreachable_rules" do
        let :original do
          grammar :S do
            rule :S  => [:SN, :V]
            rule :X  => [:SN, "Bougle"] # Unreachable
            rule :SN => "Jean"
            rule :V  => "dort"
          end
        end

        let :expected do
          grammar :S do
            rule :S  => [:SN, :V]
            rule :SN => "Jean"
            rule :V  => "dort"
          end
        end

        it "should return self" do
          expect(processor.remove_unreachable_rules).to be processor
        end

        it "should remove unreachable rules from processed grammar" do
          gram = processor.remove_unreachable_rules.result
          expect(gram).to eq expected
        end
      end

      describe "#remove_unproductive_rules" do
        let :original do
          grammar :S do
            rule :S  => [:A, 'a']
            rule :A  => [:A, 'a']
            rule :A  => 'a'
            # Symbol E is unproductive
            rule :S  => [:E, 'e']
            rule :E  => [:E, 'e']
          end
        end

        let :expected do
          grammar :S do
            rule :S  => [:A, 'a']
            rule :A  => [:A, 'a']
            rule :A  => 'a'
          end
        end

        it "should return self" do
          expect(processor.remove_unproductive_rules).to be processor
        end

        it "should remove unreachable rules from processed grammar" do
          gram = processor.remove_unproductive_rules.result
          expect(gram).to eq expected
        end
      end

      describe "#remove_epsilon_rules" do
        let :original do
          grammar :S do
            rule :S  => [:A, 'a']
            rule :A  => [:A, 'a']
            rule :A  => 'a'
          end
        end

        let :expected do
          grammar :S do
            rule :S  => [:A, 'a']
            rule :A  => [:A, 'a']
            rule :A  => 'a'
          end
        end

        it "should return self" do
          expect(processor.remove_epsilon_rules).to be processor
        end

        it "should remove unreachable rules from processed grammar" do
          gram = processor.remove_epsilon_rules.result
          expect(gram).to eq expected
        end
      end
    end
  end
end