require 'tblock'

module Gramz
  module CFG
    module Earley
      class Parser
        class States
          include TBlock

          def initialize
            @states = []
          end

          def enqueue_at(i, state)
            @states[i] ||= []
            (@states[i] << state).uniq!
          end

          def at(i)
            @states[i] ||= []
            @states[i]
          end

          def final
            @states.last
          end

          def inspect
            "States:\n" +
              @states.each_with_index.map { |set, i|
                "  #{i}:  #{set.map { |s| s.inspect }.join(', ')}"
              }.join("\n")
          end

          #def inspect
          #  "States:\n" +
          #    @states.each_with_index.map { |set, i|
          #      "    States at #{i}:\n" +
          #        set.map { |s|
          #          state = TextBlock.new([" " * 8 + s.inspect])
          #          tree = ParseTree::Formater.new(ParseTree.new(s.node)).text_block
          #          state + tree
          #        }.reduce(:/).to_s
          #    }.join("\n")
          #end
        end
      end
    end
  end
end
