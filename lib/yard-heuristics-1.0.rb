# -*- coding: utf-8 -*-

# Namespace for YARD heuristics.
module YARDHeuristics
  load File.expand_path('../yard-heuristics/version.rb', __FILE__)
  Version.load

  ParamTypes = {
    'index' => %w'Integer',
    'object' => %w'Object',
    'range' => %w'Range',
    'string' => %w'String'
  }

  ReturnTypes = {
    :<< => :self_or_type,
    :>> => :self_or_type,
    :== => %w'Boolean',
    :=== => %w'Boolean',
    :=~ => %w'Boolean',
    :<=> => %w'Integer nil',
    :+ => :type,
    :- => :type,
    :* => :type,
    :/ => :type,
    :each => %w'self',
    :each_with_index => %w'self',
    :hash => %w'Integer',
    :inspect => %w'String',
    :length => %w'Integer',
    :size => %w'Integer',
    :to_s => %w'String',
    :to_str => %w'String'
  }

  class << self
    def set_or_add_param_tag(overload, name, types)
      base = name.sub(/\A[&*]/, '')
      if tag = overload.tags.find{ |e| e.tag_name == 'param' and e.name == base }
        tag.types = types unless tag.types
      else
        tag = YARD::Tags::Tag.new(:param, '', types, base)
        if overload.respond_to? :docstring
          overload.docstring.add_tag tag
        else
          overload.tags << tag
        end
      end
      self
    end
  end
end

YARD::DocstringParser.after_parse do |parser|
  next unless YARD::CodeObjects::MethodObject === parser.object
  next if parser.text.empty? and parser.tags.empty?
  next if parser.raw_text =~ /\A\(see.*\)\z/
  name = parser.object.namespace ?
    (parser.object.namespace.namespace ?
     parser.object.namespace.relative_path(parser.object.namespace) :
     parser.object.namespace.name) :
    parser.object.name
  if parser.object.parameters.assoc('other') and
      not parser.tags.select{ |e| e.tag_name == 'param' }.
        find{ |e| YARD::Tags::RefTagList === e or e.name == 'other' }
    parser.tags <<
      YARD::Tags::Tag.new(:param, '', name, 'other')
  end
  ([parser] + parser.tags.select{ |e| YARD::Tags::OverloadTag === e }).each do |overload|
    parameters = (YARD::Tags::OverloadTag === overload and overload.parameters) ||
      parser.object.parameters
    parameters.each do |name, _|
      types = YARDHeuristics::ParamTypes[name] and
        YARDHeuristics.set_or_add_param_tag(overload, name, types)
    end
    YARDHeuristics.set_or_add_param_tag(overload, parameters.last.first, %w'Proc') if
      parameters.last and parameters.last.first =~ /\A&/

    returns = overload.tags.select{ |e| e.tag_name == 'return' }
    types = YARDHeuristics::ReturnTypes[(YARD::Tags::OverloadTag === overload and
                                         overload.name) || parser.object.name]
    case types
    when :self_or_type
      types = parser.tags.select{ |e| e.tag_name == 'param' }.find{ |e| e.name == 'other' } ?
        [name] :
        %w'self'
    when :type
      types = [name]
    end
    if types and returns.size < 2
      if returns.size == 0
        tag = YARD::Tags::Tag.new(:return, '', types)
        if overload.respond_to? :docstring
          overload.docstring.add_tag tag
        else
          overload.tags << tag
        end
      elsif not returns.first.types
        returns.first.types = types
      end
    end
  end
end

module YARD::Templates::Helpers::HtmlHelper
  alias yardheuristics_saved_htmlify htmlify
  def htmlify(text, markup = options.markup)
    yardheuristics_saved_htmlify(text, markup).gsub(/\b([[:upper:]]+)(th)?\b/){
      if $`.end_with?('$') or not YARD::CodeObjects::MethodObject === object
        $&
      else
        parameter = $1.downcase
        ((object.parameters.assoc(parameter) ||
          object.parameters.assoc('*' + parameter) ||
          object.parameters.assoc('&' + parameter) ||
          object.tags.find{ |e| e.tag_name == 'yieldparam' and e.name == parameter }) ?
         '<em class="parameter">%s</em>' % parameter :
         $1) + $2.to_s
      end
    }
  end
end
