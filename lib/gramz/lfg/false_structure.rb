module Gramz
  module LFG
    class FalseStructure
      def unify(other)
        Unification.new(self, other).compute
      end

      def to_s
        "⊥"
      end
      alias_method :inspect, :to_s
    end
  end
end
