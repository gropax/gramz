module Gramz
  module CFG
    module Earley
      class Parser
        class State
          attr_reader :rule, :current, :origin, :children

          def initialize(rule, current, origin, children = [])
            @rule, @current, @origin = rule, current, origin
            @children = children
          end

          def next_state
            State.new(@rule, @current + 1, @origin, @children.dup)
          end

          def add_children(state)
            @children << state
          end

          def next_symbol
            @rule.right_symbols[@current]
          end

          def completed?
            @current == @rule.right_symbols.length
          end

          def ==(other)
            @rule == other.rule && @current == other.current && @origin == other.origin
          end
          alias_method :eql?, :==

          def hash
            [@rule, @current, @origin].hash
          end

          def inspect
            @rule.inspect.match /^(\w+ → )(.*)$/
            lh, rh = $1, $2.split(/\s+/)

            rh.insert(@current, '•')
            rule_str = lh + rh.join(' ').gsub(/(• | •$)/, '•')

            "(#{rule_str}, #{@origin})"
          end
        end
      end
    end
  end
end
