require 'gramz/cfg/earley/parser/state'
require 'gramz/cfg/earley/parser/states'
require 'gramz/cfg/earley/parser/engine'

module Gramz
  module CFG
    module Earley

      class Parser
        def initialize(grammar, lexer = Lexer.new)
          @grammar = process_grammar(grammar)
          @lexer = lexer
        end

        def accepts?(string)
          parse(string).accepted?
        end

        def parse(string)
          symbols = @lexer.lex string
          Engine.new(@grammar, symbols).parse
        end

        private

          def process_grammar(gram)
            Grammar::Processor.new(gram)
              .expand_meta_symbols
              .result
          end
      end

    end
  end
end
