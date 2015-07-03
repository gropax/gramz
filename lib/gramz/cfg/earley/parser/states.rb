module Gramz
  module CFG
    module Earley
      class Parser
        class States
          def initialize
            @states = []
          end

          def enqueue_at(i, state)
            @states[i] ||= []
            (@states[i] << state).uniq!
          end

          def at(i)
            @states[i] ||= []
            @states[i]
          end

          def final
            @states.last
          end

          def inspect
            "States:\n" +
              @states.each_with_index.map { |set, i|
                "  #{i}:  #{set.map { |s| s.inspect }.join(', ')}"
              }.join("\n")
          end
        end
      end
    end
  end
end
