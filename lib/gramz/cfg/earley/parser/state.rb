module Gramz
  module CFG
    module Earley
      class Parser
        class State
          attr_reader :rule, :current, :origin
          def initialize(rule, current, origin)
            @rule, @current, @origin = rule, current, origin
          end

          def next_state
            State.new(@rule, @current + 1, @origin)
          end

          def next_symbol
            @rule.right_symbols[@current]
          end

          def complete?
            @current == @rule.right_symbols.length
          end

          def ==(other)
            @rule == other.rule && @current == other.current && @origin == other.origin
          end

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
