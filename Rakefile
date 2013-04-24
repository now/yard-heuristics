# -*- coding: utf-8 -*-

require 'inventory-rake-1.0'

load File.expand_path('../lib/yard-heuristics-1.0/version.rb', __FILE__)

Inventory::Rake::Tasks.define YARDHeuristics::Version, :gem => proc{ |_, s|
  s.author = 'Nikolai Weibull'
  s.email = 'now@bitwi.se'
  s.homepage = 'https://github.com/now/yard-heuristics'
}

Inventory::Rake::Tasks.unless_installing_dependencies do
  require 'lookout-rake-3.0'
  # TODO: Silence warnings generated from YARD (remove this once we plug them)
  Lookout::Rake::Tasks::Test.new :options => []
end
