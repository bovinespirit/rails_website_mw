require 'syntax/convertors/html'

class SyntaxHighlight
  def textilize(text, options = [:filter_html, :filter_styles, :hard_breaks])
    return "" if text.blank?
    RedCloth.new(text, options).to_html
  end

  def fixup_whitespace(text, convert_newlines = false)
    text = text.dup.gsub(/\s*\n\s*/, "\n")
    text
  end

  def apply_syntax_highlight(text, lang = :ruby)
    @converters ||= {}
    @converters[lang.to_sym] ||= Syntax::Convertors::HTML.for_syntax(lang.to_s)
    html = CGI::unescapeHTML(text)

    %Q{<pre class="#{lang}">} +
      @converters[lang.to_sym].convert(html, false) + '</pre>'
  end

  def highlight(text)
    html = ''
    code_lang = ''
    current_tag = []
    tokenizer = HTML::Tokenizer.new(textilize(text))
    while token = tokenizer.next
      node = HTML::Node.parse(nil, 0, 0, token, false)
      if node.tag? and node.closing == :close
        while current_tag.pop != node.name
          last if current_tag.size == 0
        end
        html << node.to_s if node.name != 'code'
        next
      end
      current_tag.push(node.name) if node.tag?
      html << case current_tag.last
        when 'code':
          if node.tag?
            code_lang = node.attributes['lang'] || ''
            ''
          else
            apply_syntax_highlight(node.to_s, code_lang)
          end
        when 'pre': node.to_s
        when nil: fixup_whitespace(node.to_s)
        else node.tag? ? node.to_s: fixup_whitespace(node.to_s, true)
      end
    end
    html
  end
end

module ActionView::Helpers::SyntaxHighlight
  def syntax_highlight(text)
    sanitize(SyntaxHighlight.new.highlight(text))
  end
end

ActionView::Base.send(:include, ActionView::Helpers::SyntaxHighlight)

