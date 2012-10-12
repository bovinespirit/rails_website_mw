module PhotoTagsHelper

   # Create an image tag for a photo, identified by its slug
  def photo_tag(photo, options = {})
    options.symbolize_keys
    options[:src] = thumb_url(:photo => photo, :size => 'main.jpg')
    options[:alt] ||= photo.title
    options[:title] ||= photo.title
    options[:width], options[:height] = photo.size
    tag('img', options)
  end
  
  # Create a thumbnail link to a photo
  #   photo_set - photo_set for link, nil if not known
  #   photo - photo
  #   size - size of thumbnail
  #   loptions - link options
  #   ioptions - image options
  def thumb_link_tag(photo_set, photo, size, loptions = {}, ioptions = {})
    loptions.symbolize_keys
    loptions[:href] ||= photo_set.nil? ? photonoset_url(:photo => photo) : 
                                         photoshow_url(:photo_set => photo_set, :photo => photo)
    if loptions.has_key?(:title)
      ioptions[:title] ||= loptions[:title]
      ioptions[:alt] ||= loptions[:title]
    end
    content_tag('a', thumb_tag(photo, size, ioptions), loptions)
  end
    
  # Create a thumbnail of photo
  def thumb_tag(photo, size, options = {})
    options.symbolize_keys
    options[:src]= thumb_url(:photo => photo, :size => "#{size}.jpg")
    options[:alt] ||= photo.title
    options[:title] ||= photo.title
    options[:width], options[:height] = photo.size(size)
    tag('img', options)
  end  

  # Create preview thumbnail tag
  def thumb_preview_tag(params, size, options = {})
    options.symbolize_keys
    photo = Photo.find_by_slug(params[:slug])
    photo.update_attributes(params)
    options[:src]= thumbpre_url(:slug => params[:slug],
                                :size => size, 
                                :x => params[:thumb_x], 
                                :y => params[:thumb_y],
                                :l => params[:thumb_l], 
                                :v => params[:thumb_vertical])
    options[:alt] ||= photo.title
    options[:title] ||= photo.title
    options[:width], options[:height] = photo.size(size)
    tag('img', options)
  end  
  
  # Create thumbnail with caption
  # Extra_div_classes can be 'float' 'clear' etc
  # This can't be done with a partial as comatose won't be able to render it
  def captioned_thumb(photo_set, photo, size, link_options = {})
    link_options[:class] = link_options[:class].to_s + ' caption'
    link_options[:href] = photoshow_url(:photo => photo, :photo_set => photo_set)
    image_options = {}    
    image_options[:src]= thumb_url(:photo => photo, :size => "#{size}.jpg")
    image_options[:alt] ||= photo.title
    image_options[:title] ||= photo.title
    image_options[:width], image_options[:height] = photo.size(size)
    img_tag = tag('img', image_options)
    background_image = thumbbg_url(:photo => photo, :size => "#{size}.jpg")
    inner_div_options = {:style => "width: #{image_options[:width]}px; " + 
                                   "background-image: url(#{background_image})"}
    div_str = photo.has_title? ? content_tag('h3', photo.title) : ""
    div_str << "#{process_text(photo.description)}"
    div_str << "#{content_tag('span', photo_create_date(photo), {:class => 'date'})}"
    inner_div_tag = content_tag('div', div_str, inner_div_options)
    content_tag('a', "#{inner_div_tag}#{img_tag}", link_options)
  end
  
  # Create thumb_card, contains photo with caption underneath
  # No title and no space for title if title = nil
  # Space for title if title = ""
  def thumb_card(photo_set, photo, size, title = nil, url = nil, classes = '')
    str = ""
    str << %Q|<div class="thumb-card-#{size} #{classes}">|
    str << thumb_link_tag(photo_set, photo, size, 
                          {:href => url}, 
                          {:class => photo.thumb_vertical ? "vertical" : "horizontal"})
    unless title.nil?
      str << "<h3>&#160;"
      str << link_to(title, url)
      str << "</h3>"
    end
    str << "</div>\n"
    return str
  end
  
  def photo_create_date(photo)
    strf = photo.vague_created_date ? "%b %Y" : "%d %b %Y"
    photo.created_on.strftime(strf)
  end
end
