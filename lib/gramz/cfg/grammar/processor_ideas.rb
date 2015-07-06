# What I want
#
# Isolate independent process into different classes
# Keep track of grammar transformations by memorizing original and result
# Being able to form new processes by combining other simpler processes
# Not executing processes that are not necessary
#
class Processor
  def self.proceed_if(sym)
    @condition = -> { send(sym) }
  end

  def self.process(sym)
    @process = -> { send(sym) }
  end

  def self.before(*syms)
    # @todo
  end


  attr_reader :original
  def initialize(grammar)
    @original = grammar
  end

  def grammar
    @processed
  end

  def process_needed?
    !!@condition.call
  end

  def process
    if process_needed?
      @processed = @original.dup
      @process.call
      @process_performed = true
    else
      @process_performed = false
    end
  end

  def result
    @process_performed ? @processed : @original
  end
end

class RemoveUnreachable < Proccessor
  proceed_if :has_unreachable_symbols?
  proccess :remove_unreachable_symbols
end
