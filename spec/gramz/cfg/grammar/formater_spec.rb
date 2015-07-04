require 'spec_helper'

module Gramz::CFG
  class Grammar
    describe Formater do
      include DSL

      let(:gram) {
        grammar :S do
          rule :S  => [:SN, :V]
          rule :SN => "Jean"
          rule :V  => "dort"
        end
      }
      let(:formater) { Formater.new(gram) }

      describe "#format" do
        it "should return a pretty representation of the structure" do
          #expected = <<-EOS.strip.gsub(/ {12}/, '')
          #  ╔═ Context-free Grammar ══╗
          #  ║  Initial: S             ║
          #  ║  Non Terminals: S SN V  ║
          #  ║  Terminals: Jean dort   ║
          #  ╟─ Productions ───────────╢
          #  ║  (1)  S  → SN V         ║
          #  ║  (2)  SN → Jean         ║
          #  ║  (3)  V  → dort         ║
          #  ╚═════════════════════════╝
          #EOS
          expected = <<-EOS.strip.gsub(/^ {12}/, '')
            Grammar
              Non Terminal: S SN V
              Terminal: Jean dort
              Initial: S
              Rules:
                S  → SN V
                SN → Jean
                V  → dort
          EOS
          expect(formater.format).to eq expected
        end
      end
    end
  end
end
