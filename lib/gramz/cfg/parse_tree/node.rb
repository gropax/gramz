module Gramz
  module CFG
    class ParseTree
      class Node
        attr_accessor :value, :children
        def initialize(value)
          @value = value
          @children = []
        end

        def add_child(node)
          check_is_a_node! node
          @children << node
        end

        def terminal?
          @children.empty?
        end

        def non_terminal?
          !terminal?
        end

        def ==(other)
          @value == other.value && @children == other.children
        end

        def format(formater = Formater.new(self))
          formater.format
        end

        def check_is_a_node!(param)
          unless param.is_a? Node
            raise TypeError, "Node expected, found: #{param.class}"
          end
        end
      end
    end
  end
end
