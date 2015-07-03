require 'tblock'

module Gramz
  module LFG
    class TraitStructure
      class Formater
        include TBlock

        def initialize(struct)
          @structure = struct
        end

        def format
          text_block.to_s
        end

        def text_block
          return TextBlock.new ['⊥'] if @structure.is_a?(FalseStructure)
          return TextBlock.new ['∅'] if @structure.traits.empty?

          table = @structure.traits.map { |t|
            [TextBlock.new([t.name.to_s]), format_value(t.value)]
          }
          grid = GridLayout.new(table, {separator_v: 1})

          brackets = Brackets.new(grid, {
            wrap_top: wrap_top?,
            wrap_bottom: wrap_bottom?,
          }).build
        end

        private

          def format_value(value)
            if value.is_a? TraitStructure
              self.class.new(value).text_block
            else
              a = value.atom
              s = a.is_a?(String) ? "'#{a}'" : " #{a}"
              TextBlock.new [s]
            end
          end

          def wrap_top?
            !trait_is_structure?(:first)
          end

          def wrap_bottom?
            !trait_is_structure?(:last)
          end

          def trait_is_structure?(sym)
            @structure.traits.send(sym).value.is_a? TraitStructure
          end
      end
    end
  end
end
