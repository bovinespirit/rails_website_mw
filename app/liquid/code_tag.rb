require 'syntax/convertors/html'

class Code < Liquid::Block
  def initialize(markup, tokens)
    super 
    if markup =~ /(\w+)/
      @lang = $1
    else
      raise SyntaxError.new("Syntax Error in 'syntax' - Valid syntax: syntax [language]")
    end
  end
  
  def render(context)
    text = super.join
    "<notextile>" + SyntaxHighlight.new.apply_syntax_highlight(text, @lang) + "</notextile>"
  end
end

Liquid::Template.register_tag('code', Code)