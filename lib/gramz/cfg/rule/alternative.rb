module Gramz
  module CFG
    class Rule
      class Alternative
        attr_reader :left_symbol
        def initialize(lsym, alts)
          @left_symbol = lsym
          @ary = alts
        end

        def [](i)
          @ary[i]
        end

        include Enumerable
        def each(&blk)
          @ary.each { |a| yield a }
        end
      end
    end
  end
end
