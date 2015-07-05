require_relative 'parse_tree/node'
require_relative 'parse_tree/formater'

module Gramz
  module CFG
    class ParseTree
      def self.builder(root_val, nodes = nil)
        root = Node.new(root_val)
        build_nodes(nodes).each { |n| root.add_child n }
        ParseTree.new(root)
      end

      def self.build_nodes(param)
        case param
        when Hash
          param.map { |k, v|
            node = Node.new k
            build_nodes(v).each { |n| node.add_child n }
            node
          }
        when Array
          param.map { |x| Node.new x }
        when nil
          []
        else
          [Node.new(param)]
        end
      end


      attr_reader :root
      def initialize(root)
        @root = root
      end

      def format(formater = Formater.new(self))
        formater.format
      end

      def format_debug
        format_node(@root)
      end

      def format_node(node)
        if node.terminal?
          node.value.to_s
        else
          nodes_str = [node.value.to_s, *node.children.map { |n| format_node n }].join(' ')
          "[#{nodes_str}]"
        end
      end

      def inspect
        format_debug
      end

    end
  end
end
