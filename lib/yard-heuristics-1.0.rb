# -*- coding: utf-8 -*-

# Namespace for YARD heuristics.
module YARDHeuristics
  load File.expand_path('../yard-heuristics/version.rb', __FILE__)
  Version.load
end

YARD::DocstringParser.after_parse do |parser|
  next unless YARD::CodeObjects::MethodObject === parser.object
  if parser.object.parameters.assoc('other') and not parser.tags.select{ |e| e.tag_name == 'param' }.find{ |e| e.name == 'other' }
    parser.tags <<
      YARD::Tags::Tag.new(:param,
                          '',
                          parser.object.namespace.namespace ?
                            parser.object.namespace.relative_path(parser.object.namespace) :
                            parser.object.namespace,
                          'other')
  end
  returns = parser.tags.select{ |e| e.tag_name == 'return' }
  if [:===, :==, :=~].include? parser.object.name and returns.size < 2
    if returns.empty?
      parser.tags << YARD::Tags::Tag.new(:return, '', %w'Boolean')
    elsif not returns.first.types
      returns.first.types = %w'Boolean'
    end
  end
  returns.reject{ |e| e.types }.each do |e|
    e.types = [$1] if /\A(?:(?:An?|The)\s+)?+.*?([[:upper:]][^[:space:]]*)/ =~ e.text
  end
end
