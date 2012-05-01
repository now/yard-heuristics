# -*- coding: utf-8 -*-

Expectations do
  expect [['other', %w'A']] do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A
  # Placeholder
  def a(other)
  end
end
EOS
  YARD::Registry.at('A#a').docstring.tags(:param).map{ |e| [e.name, e.types] }
  end
end
