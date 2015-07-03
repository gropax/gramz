require 'tblock'

module Gramz
  module LFG
    class Unification
      class Formater
        include TBlock

        def initialize(unif)
          @unification = unif
        end

        def format
          text_block.to_s
        end

        def text_block
          s1, s2 = @unification.structures.map { |s|
            TraitStructure::Formater.new(s).text_block
          }
          union, equal = ['U', '='].map { |sym|
            TextBlock.new([sym]).center(5)
          }

          if @unification.computed?
            result = TraitStructure::Formater.new(@unification.result).text_block
          else
            result = TextBlock.new ['???']
          end

          s1 + union + s2 + equal + result
        end
      end
    end
  end
end
