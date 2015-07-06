module Gramz
  module CFG
    module Symbol
      class Base
        attr_reader :internal
        def initialize(value)
          @value = value
          @internal = value.to_s.upcase.to_sym
        end

        def eql?(other)
          terminal? == other.terminal? && @internal.eql?(other.internal)
        end
        alias_method :==, :eql?

        def hash
          [@internal, terminal?].hash
        end

        def to_sym
          @internal.to_sym
        end

        def to_s
          @value.to_s
        end

        def non_terminal?
          !terminal?
        end
      end

      class Terminal < Base
        def terminal?
          true
        end
      end

      class NonTerminal < Base
        def terminal?
          false
        end
      end

      Start = NonTerminal.new(:"0")
      def Start.inspect
        "#<CFG::Symbol::Start>"
      end

      End = Terminal.new(:"$")
      def End.inspect
        "#<CFG::Symbol::End>"
      end
    end
  end
end
