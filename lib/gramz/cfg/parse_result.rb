module Gramz
  module CFG
    class ParseResult
      attr_reader :parse_trees

      def initialize(success, parse_trees)
        @success = success
        @parse_trees = parse_trees
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
