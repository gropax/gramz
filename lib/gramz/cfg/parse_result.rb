module Gramz
  module CFG
    class ParseResult
      attr_reader :parse_trees, :states

      def initialize(success, parse_trees, states)
        @success = success
        @parse_trees = parse_trees
        @states = states
      end

      def accepted?
        @success
      end

      def rejected?
        !@success
      end
    end
  end
end
