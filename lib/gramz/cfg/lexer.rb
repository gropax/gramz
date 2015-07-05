module Gramz
  module CFG
    class Lexer
      def lex(str)
        str.split(/\s/).map { |s| Symbol::Terminal.new s }
      end
    end
  end
end
