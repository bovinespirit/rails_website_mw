module PhotoHelper
  # Read a field from a Photo model
  # Make sure it's not nil, 'No Data', 0 or false
  # Then display it.
  # extra can be a :prefix for the data or a :postfix, or both
  def data_with_label(text, data, extra = {})
    disp = false
    if data.is_a?(String)
      disp = true unless (data.strip.size == 0 or data.downcase == "no data")
      text << ":&#160;"
    elsif data.is_a?(Float)
      disp = true unless data == 0
      data = data.to_s
      text << ":&#160;"
    else
      disp = data
      data = ""
    end
    pre = extra[:prefix] || ''
    post = extra[:postfix] || ''
    disp ? content_tag('li', content_tag('em', text) + pre + data + post) : ""
  end

# Photo Carousel larks
  def carousel_data(photo_set, photo, dir, current_photo)
    data = {:dir => dir}
    case dir
    when :prev
      data[:cethumb] = photo
      data[:newthumb] = photo.prev(photo_set, current_photo)
      data[:newrootthumb] = data[:newthumb]
      data[:oldthumb] = photo.next(photo_set, current_photo)
    when :next
      data[:cethumb] = photo.next(photo_set, current_photo)
      data[:newrootthumb] = data[:cethumb]
      data[:newthumb] = data[:cethumb].next(photo_set, current_photo)
      data[:oldthumb] = photo
    end
    data[:oldelem] = "thumb_#{data[:oldthumb].id}"
    data[:newelem] = "thumb_#{data[:newthumb].id}"
    data[:ceelem] = "thumb_#{data[:cethumb].id}"
    return data
  end

  def carousel_inactive_link(dir, options = {})
    case dir
    when :prev
      options[:class] = "#{options[:class]} prev"
      content_tag('div', '&#171;more', options)
    when :next
      options[:class] = "#{options[:class]} next"
      content_tag('div', 'more&#187;', options)
    end
  end
  
  def carousel_link(photo_set, dir, photo, current_photo)
    carousel_inactive_link(dir,
                           :class => 'on',
                           :onclick => remote_function(:url => carousel_url(
                                                                 :photo_set => photo_set,
                                                                 :dir => (dir == :prev) ? 'prev.js' : 'next.js', 
                                                                 :photo => photo,
                                                                 :current => current_photo)))
  end
  
  # Create html for a thumbnail link
  def carousel_thumb(photo_set, photo, pos = :left, display = 'none')
    xtraclass = (photo.thumb_vertical) ? 'vertical' : 'horizontal' 
    style = "display:#{display};"
    thumb_link_tag(photo_set, photo, 'xsmall',
                   { :style => style, :class => "float #{xtraclass}", :id => "thumb_#{photo.id}" })
  end
end
