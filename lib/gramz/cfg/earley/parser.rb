require 'gramz/cfg/earley/parser/state'
require 'gramz/cfg/earley/parser/states'
require 'gramz/cfg/earley/parser/engine'

module Gramz
  module CFG
    module Earley

      class Parser
        def initialize(grammar, lexer = Lexer.new)
          @grammar = grammar
          @lexer = lexer
        end

        def accepts?(string)
          parse(string).accepted?
        end

        def parse(string)
          symbols = @lexer.lex string
          Engine.new(@grammar, symbols).parse
        end
      end

    end
  end
end
