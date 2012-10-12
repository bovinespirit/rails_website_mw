
class StylesheetController < ApplicationController
  layout nil
  session :off

  def rcss
    if rcssp = params[:rcss]
      file_base = rcssp.gsub(/\.css$/i, '')
      file_path = "#{RAILS_ROOT}/app/views/stylesheets/#{file_base}.rcss"
      render_css(:file => file_path, :content_type => "text/css")
      cache_page
    else
      render(:nothing => true, :status => 404)
    end
  end
  
  private
  def render_css(options = {})
    str = render_to_string({ :file => options[:file] })
    l1 = str.length
    options.delete(:file)
    str = str.gsub(/^[\s]+/, '')      # Remove leading spaces
    str = str.gsub(/\{\s*\n/, '{')    # Remove newline after '{'
    str = str.gsub(/;\s*\n/, ';')     # Remove newline after ';'
    str = str.gsub(/\s*,\s*\n*/, ',') # Remove spaces, newline after ','
    str = str.gsub(/\n*\s*\}/, '}')   # Remove newline before '}'
    str = str.gsub(/:\s+/, ':')       # Remove space after ':'
    l2 = str.length
    logger.info("RCSS in:#{l1} out:#{l2} ratio:#{l2.to_f/l1.to_f}")
    render({ :text => str }.merge(options))
  end
end
