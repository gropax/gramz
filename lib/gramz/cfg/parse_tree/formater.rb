require 'tblock'

module Gramz
  module CFG
    class ParseTree

      class Formater
        include TBlock

        def initialize(parse_tree)
          @parse_tree = parse_tree
        end

        def format
          text_block.to_s
        end

        def text_block
          node_block(@parse_tree.root)
        end

        def node_block(node)
          if node.terminal?
            terminal_block(node)
          elsif node.children.size == 1
            single_child_block(node)
          else
            multiple_children_blocks(node)
          end
        end

        private

          def terminal_block(node)
            TextBlock.new [" #{node.value} "]
          end

          def single_child_block(node)
            self_block = TextBlock.new [node.value.to_s]
            vbar = TextBlock.new ["│"]
            child_blk = node_block(node.children.first)

            self_block / vbar / child_blk
          end

          def multiple_children_blocks(node)
            blks = node.children.map { |n| node_block(n) }

            br_pos = branch_positions(blks)
            hbar = horizontal_bar(br_pos)

            max_height = blks.map(&:height).max
            children = blks.map { |b| b.ujust(max_height) }.reduce(:+)

            offset = TextBlock.new([" " * br_pos[0]])

            upper = TextBlock.new([" #{node.value}"]) / hbar
            pos_upper = (offset + upper).ljust(children.width)

            pos_upper / children
          end

          def horizontal_bar(br_pos)
            hbar = '┌' +
              (1..br_pos.length-1).map { |i|
                '─' * (br_pos[i] - br_pos[i-1] -1)
              }.join('┬') + '┐'

            top_pos = (hbar.length - 1) / 2
            hbar[top_pos] = hbar[top_pos] == '┬' ? '┼' : '┴'

            TextBlock.new [hbar]
          end

          def branch_positions(blks)
            offset = 0
            blks.map { |b|
              l = b.lines.first
              l.match /(\s*)(\S+)\s*/
              pos = ($2.length - 1) / 2 + $1.length + offset
              offset += b.width
              pos
            }
          end

      end

    end
  end
end
