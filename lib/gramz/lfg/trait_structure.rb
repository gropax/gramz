require 'gramz/lfg/trait_structure/formater'

module Gramz
  module LFG
    class TraitStructure
      def self.from_hash(hsh = {})
        traits = hsh.map do |k, v|
          val = v.is_a?(Hash) ? from_hash(v) : AtomicValue.new(v)
          Trait.new(k, val)
        end
        TraitStructure.new traits
      end

      def initialize(traits = [])
        # Store traits in a hash, to access them by their name
        @traits = Hash[traits.map { |t| [t.name, t] }]
      end

      def unify(other)
        Unification.new(self, other).compute
      end

      def traits
        @traits.values
      end

      def ==(other)
        @traits == other.traits_hash
      end

      def inspect
        Formater.new(self).format
      end

      protected

        def traits_hash
          @traits
        end
    end
  end
end
