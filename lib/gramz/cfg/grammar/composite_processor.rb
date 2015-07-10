module Gramz
  module CFG
    class Grammar
      class CompositeProcessor < Processor

        def self.process(sym)
          alias_method sym, :process_grammar
          @@processors[sym] = self
        end

        def self.condition(sym)
          alias_method sym, :apply?
        end

        def self.processors
          @processors ||= []
        end

        def self.compose(*syms)
          @processors = syms.map { |s| registered_processor(s) }
        end


        attr_reader :processors

        def initialize(grammar, processors = self.class.processors)
          @original = grammar
          @processors = processors
        end

        def process_grammar
          @processors.reduce(@original) { |gram, pro|
            pro.new(gram).process.result
          }
        end

        def apply?
          @processors.any? { |pro| pro.new(@original).apply? }
        end
      end
    end
  end
end
