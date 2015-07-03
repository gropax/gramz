module Gramz
  module LFG
    class Trait
      attr_reader :name, :value
      def initialize(name, tval)
        @name, @value = name.to_sym, tval
      end

      def ==(other)
        @name == other.name && @value == other.value
      end

      def inspect(ljust = 0)
        "#{name.to_s.ljust(ljust)} #{value.inspect}"
      end
    end
  end
end
