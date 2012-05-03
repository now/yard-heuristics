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

  expect %w'self' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A
  # Placeholder
  def each
  end
end
EOS
    YARD::Registry.at('A#each').docstring.tags(:return).first.types
  end

  expect %w'self' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A
  # @overload
  #   Enumerates objects
  #
  #   @yieldparam [Object] object
  # @overload
  #   @return [Enumerator<Object>] An Enumerator
  def each
  end
end
EOS
    YARD::Registry.at('A#each').docstring.tags(:overload).first.tag(:return).types
  end

  expect %w'A' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A
  # @return The addition of the receiver and _other_
  def +(other)
  end
end
EOS
    YARD::Registry.at('A#+').docstring.tags(:return).first.types
  end

  expect %w'A' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A
  # @return The shifted value
  def <<(other)
  end
end
EOS
    YARD::Registry.at('A#<<').docstring.tags(:return).first.types
  end

  expect %w'self' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A
  # @return The shifted value
  def <<(element)
  end
end
EOS
    YARD::Registry.at('A#<<').docstring.tags(:return).first.types
  end

  expect %w'Range' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
# A
def a(range)
end
EOS
    YARD::Registry.at('#a').docstring.tags(:param).last.types
  end

  expect %w'Integer' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
# A
def a(index)
end
EOS
    YARD::Registry.at('#a').docstring.tags(:param).last.types
  end

  expect %w'Proc' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
# @return The shifted value
def a(&block)
end
EOS
    YARD::Registry.at('#a').docstring.tags(:param).last.types
  end
end
