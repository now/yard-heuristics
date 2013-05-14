# -*- coding: utf-8 -*-

require 'inventory-1.0'

module YARDHeuristics
  Version = Inventory.new(1, 2, 1){
    def dependencies
      super + Inventory::Dependencies.new{
        development 'inventory-rake', 1, 4, 0
        development 'lookout', 3, 0, 0
        development 'lookout-rake', 3, 0, 0
        runtime 'yard', 0, 8, 0, :feature => 'yard'
      }
    end
  }
end
