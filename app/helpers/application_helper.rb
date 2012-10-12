# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include PhotoTagsHelper
  include PostHelper
  include TagHelper
  MENU_LIMIT = 8
  
  # Send text through a TextFilter, using the Comatose::ProcessingContext
  # It won't all work unless set_url_writer has been called by the controller
  def process_text(text, filter_type = 'Textile', options = {})
    binding = Comatose::ProcessingContext.new(ComatosePage.new, options)
    TextFilters.transform(text, binding, filter_type)
  end
  
  # Create a link to the shortcut icon.  By default this is in public/
  def shortcut_link_tag(source = "/favicon.ico", options = {})
    options.symbolize_keys!
    options[:href] = image_path(source)
    options[:rel] = "shortcut icon"
    tag("link", options)
  end

  # Create a <link /> link
  def rel_link(rel, href, title = "", options = {})
    options.symbolize_keys!
    options[:href] ||= href
    options[:rel] ||= rel
    options[:title] ||= title if !title.empty?
    tag("link", options)
  end
    
  # Create a link for menus
  # No link if main == page
  def menu_link(page, main)
    link_to_unless(main == page, page.menu_title || page.title, page.uri)
  end
  
  def show_validation_icons?
    return false
  end
end