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

=begin Disabled due to bug in YARD
  expect [%w'self'] do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
# @return [self]
def b(&block)
end
# (see #b)
def <<(&block)
end
EOS
  YARD::Registry.at('#<<').docstring.tags(:return).map{ |e| e.types }
  end
=end

  expect 'Emphasizes <em class="parameter">parameter</em>.' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
# Emphasizes PARAMETER.
def a(parameter)
end
EOS
    Module.new{
      class << self
        include YARD::Templates::Helpers::HtmlHelper
        def options
          YARD::Templates::TemplateOptions.new{ |o|
            o.reset_defaults
          }
        end
        def object
          YARD::Registry.at('#a')
        end
      end
    }.instance_eval{
      htmlify(YARD::Registry.at('#a').docstring)
    }
  end

  expect 'The <em class="parameter">index</em>th element.' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
# The INDEXth element.
def a(index)
end
EOS
    Module.new{
      class << self
        include YARD::Templates::Helpers::HtmlHelper
        def options
          YARD::Templates::TemplateOptions.new{ |o|
            o.reset_defaults
          }
        end
        def object
          YARD::Registry.at('#a')
        end
      end
    }.instance_eval{
      htmlify(YARD::Registry.at('#a').docstring)
    }
  end

  expect 'The value of $VERBOSE.' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
# The value of $VERBOSE.
def a(verbose)
end
EOS
    Module.new{
      class << self
        include YARD::Templates::Helpers::HtmlHelper
        def options
          YARD::Templates::TemplateOptions.new{ |o|
            o.reset_defaults
          }
        end
        def object
          YARD::Registry.at('#a')
        end
      end
    }.instance_eval{
      htmlify(YARD::Registry.at('#a').docstring)
    }
  end

  expect 'Yields the <em class="parameter">exception</em>.' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
# Yields the EXCEPTION.
# @yieldparam [Exception] exception
def a
end
EOS
    Module.new{
      class << self
        include YARD::Templates::Helpers::HtmlHelper
        def options
          YARD::Templates::TemplateOptions.new{ |o|
            o.reset_defaults
          }
        end
        def object
          YARD::Registry.at('#a')
        end
      end
    }.instance_eval{
      htmlify(YARD::Registry.at('#a').docstring)
    }
  end

  expect 'Yields the <em class="parameter">exception</em>.' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
# Yields the EXCEPTION.
# @option options [Exception] :exception
def a(options = {})
end
EOS
    Module.new{
      class << self
        include YARD::Templates::Helpers::HtmlHelper
        def options
          YARD::Templates::TemplateOptions.new{ |o|
            o.reset_defaults
          }
        end
        def object
          YARD::Registry.at('#a')
        end
      end
    }.instance_eval{
      htmlify(YARD::Registry.at('#a').docstring)
    }
  end
end
