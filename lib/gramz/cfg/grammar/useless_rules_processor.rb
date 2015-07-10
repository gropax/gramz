module Gramz
  module CFG
    class Grammar
      #class UselessRulesProcessor < Processor
      #  process :remove_useless_rules
      #  condition :has_useless_symbols?
#
#        before :remove_unreachable_rules,
#               :remove_unproductive_rules
#      end

      class UselessRulesProcessor < CompositeProcessor
        process :remove_useless_rules
        condition :has_useless_symbols?

        compose :remove_unreachable_rules,
                :remove_unproductive_rules
      end
    end
  end
end
