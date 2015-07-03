module Gramz
  module LFG
    class AtomicValue
      attr_reader :atom
      def initialize(atom)
        @atom = atom
      end

      def ==(other)
        @atom == other.atom
      end

      def inspect
        @atom.to_s
      end
    end
  end
end
