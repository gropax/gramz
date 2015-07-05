require 'spec_helper'

module Gramz::CFG
  class ParseTree
    describe Formater do
      let(:formater) { Formater.new(tree) }

      describe "#format" do
        context "terminal node" do
          let(:tree) { ParseTree.builder("chat") }

          it "should return the value as string with spaces around" do
            expect(formater.format).to eq " chat "
          end
        end

        context "node with one terminal child" do
          let(:tree) { ParseTree.builder(:N, "chat") }

          it "should return a tree" do
            expected = <<-EOS.gsub(/^ {14}/, '').gsub(/\n$/, '')
                N   
                │   
               chat 
            EOS
            expect(formater.format).to eq expected
          end
        end

        context "node with 2 terminal children" do
          let(:tree) { ParseTree.builder :SN, ["Le", "chat"] }

          it "should return a tree" do
            expected = <<-EOS.gsub(/^ {14}/, '').gsub(/\n$/, '')
                 SN     
               ┌─┴──┐   
               Le  chat 
            EOS
            expect(formater.format).to eq expected
          end
        end

        context "node with 3 terminal children" do
          let(:tree) { ParseTree.builder :SN, ["Le", "chat", "mignon"] }

          it "should return a tree" do
            tree = ParseTree.builder :SN, ["Le", "chat"]
            expected = <<-EOS.gsub(/^ {14}/, '').gsub(/\n$/, '')
                     SN         
               ┌────┬┴─────┐    
               Le  chat  mignon 
            EOS
            expect(formater.format).to eq expected
          end
        end

        context "node with 3 balanced terminal children" do
          let(:tree) { ParseTree.builder :SN, ["Le", "joli", "chat"] }

          it "should return a tree" do
            tree = ParseTree.builder :SN, ["Le", "chat"]
            expected = <<-EOS.gsub(/^ {14}/, '').gsub(/\n$/, '')
                    SN        
               ┌────┼─────┐   
               Le  joli  chat 
            EOS
            expect(formater.format).to eq expected
          end
        end

        context "node with 2 non terminal children" do
          let(:tree) { ParseTree.builder(:SN, {D: "Le", N: "chat"}) }

          it "should return a tree" do
            expected = <<-EOS.gsub(/^ {14}/, '').gsub(/\n$/, '')
                 SN     
               ┌─┴──┐   
               D    N   
               │    │   
               Le  chat 
            EOS
            expect(formater.format).to eq expected
          end
        end

        context "node with 2 non terminal children" do
          let(:tree) { ParseTree.builder(:SN, {D: "Le", A: "joli", N: "chat"}) }

          it "should return a tree" do
            expected = <<-EOS.gsub(/^ {14}/, '').gsub(/\n$/, '')
                    SN        
               ┌────┼─────┐   
               D    A     N   
               │    │     │   
               Le  joli  chat 
            EOS
            expect(formater.format).to eq expected
          end
        end

        context "complexe example" do
          let(:tree) {
            ParseTree.builder("S", {
              "SN" => {
                "D" => "Le",
                "N" => "chat"
              },
              "SV" => {
                "V" => "mange",
                "SN" => {
                  "D" => "une",
                  "N" => "souris"
                }
              },
            })
          }

          it "should return a tree" do
            expected = <<-EOS.gsub(/^ {14}/, '').gsub(/\n$/, '')
                        S                   
                 ┌──────┴──────┐            
                 SN            SV           
               ┌─┴──┐      ┌───┴────┐       
               D    N      V        SN      
               │    │      │     ┌──┴──┐    
               Le  chat  mange   D     N    
                                 │     │    
                                une  souris 
            EOS
            expect(formater.format).to eq expected
          end
        end
      end
    end
  end
end
