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

  expect %w'A' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A
  # @return A new A adjusted by _other_.
  def a(other)
  end
end
EOS
  YARD::Registry.at('A#a').docstring.tags(:return).first.types
  end
end
