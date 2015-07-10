module Gramz
  module CFG
    class Grammar
      class Processor
        ProcessorError = Class.new StandardError

        class << self
          def registered_processor(sym)
            @@processors[sym] || raise(ProcessorError, "Unknown processor #{sym}")
          end

          def registered_processors
            @@processors ||= {}
          end


          def process(sym, &block)
            if block
              define_method(sym) { instance_eval &block }
              alias_method :process_grammar, sym
            else
              define_method(:process_grammar) {
                if respond_to?(sym) then send(sym) else
                  raise ProcessorError, "Undefined process method for #{self}"
                end
              }
            end
            registered_processors[sym] = self
          end

          def condition(sym, &block)
            if block
              define_method(sym) { instance_eval &block }
              alias_method :apply?, sym
            else
              define_method(:apply?) {
                if respond_to?(sym) then send(sym) else
                  raise ProcessorError, "Undefined condition method for #{self}"
                end
              }
            end
          end
        end


        attr_reader :original, :result

        def initialize(grammar)
          @original = grammar
        end

        def process
          @result = process_grammar
          self
        end

        def apply?
          true
        end
      end
    end
  end
end


__END__

        def process2
          unless meth = self.class.process_method
            raise ProcessorError, "Undefined process method"
          end

          pre_processed = self.class.pre_processors.reduce(@original) { |p, g|
            p.new(g).process.result
          }

          if respond_to?(meth)
            @result = send(meth, pre_processed)
          else
            @result = pre_processed
          end

          self
        end

