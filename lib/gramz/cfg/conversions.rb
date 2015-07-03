module Gramz
  module CFG
    module Conversions
      def Symbol(param)
        case param
        when Symbol::Base
          param
        when ::Symbol
          Symbol::NonTerminal.new(param)
        when ::String
          Symbol::Terminal.new(param)
        else
          raise TypeError, "Symbol or String expected, found #{param.class}."
        end
      end

      def Terminal(param)
        case param
        when Symbol::Terminal
          param
        when ::Symbol, ::String
          Symbol::Terminal.new(param)
        else
          raise TypeError, "Invalid parameter: #{param.class}."
        end
      end
    end
  end
end
