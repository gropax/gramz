require 'gramz/lfg/unification/formater'

module Gramz
  module LFG
    class Unification
      UnificationError = Class.new StandardError

      attr_reader :structures
      def initialize(struct1, struct2)
        @structures = [struct1, struct2]
      end

      def compute
        @result ||= unify_values(*@structures)
        self
      end

      def result
        @result || raise(UnificationError, "Unification has not been computed yet.")
      end

      def computed?
        !@result.nil?
      end

      def failure?
        result.is_a?(FalseStructure)
      end

      def success?
        !failure?
      end

      def inspect
        Formater.new(self).format
      end

      private

        def unify_values(v1, v2)
          case v1
          when TraitStructure
            unify_trait_structures(v1, v2)
          when AtomicValue
            unify_atomic_values(v1, v2)
          when FalseStructure #, PredicateValue
            FalseStructure.new
          else
            raise TypeError, "Expected TraitValue, found #{v1.class}"
          end
        end

        def unify_atomic_values(v1, v2)
          if v2.is_a?(AtomicValue) && v1.atom == v2.atom
            AtomicValue.new(v1.atom)
          else
            FalseStructure.new
          end
        end

        def unify_trait_structures(v1, v2)
          return FalseStructure.new unless v2.is_a?(TraitStructure)

          traits = [v1, v2].map(&:traits).flatten.group_by(&:name).map do |name, ts|
            ts.reduce { |t1, t2| unify_traits(t1, t2) }
          end
          traits.all? ? TraitStructure.new(traits) : FalseStructure.new
        end

        def unify_traits(t1, t2)
          v = unify_values(t1.value, t2.value)
          v.is_a?(FalseStructure) ? nil : Trait.new(t1.name, v)
        end
    end
  end
end
