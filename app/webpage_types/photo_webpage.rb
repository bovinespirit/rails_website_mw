
Webpage.webpage_for_class(Photo) do
  def initialize(obj, depth = 0, locals = {})
    @object = obj
    @uri = "/photo/show/#{@object.to_param}"
    @changefreq = :monthly
    super
  end

  def title
    @object.title
  end
  alias menu_title title

  def updated_on
    @object.updated_on
  end

  def edit_url
    edit_photo_url(@object)
  end
    
  protected
  def load_parent
    return ComatosePage.find_by_slug('photos')
  end
end # PhotoWebpage

Webpage.webpage_for_class(PhotosPhotoSet) do
  def initialize(obj, depth = 0, locals = {})
    @changefreq = :monthly
    super
    @show_in_menu = false
  end
  
  def title
    "#{photo_set.title} - #{photo.title}"
  end
  
  def menu_title
    photo.title
  end
  alias crumb_title menu_title
  
  def updated_on
    photo.updated_on
  end
  
  def uri
    "/photo/set/#{photo_set.to_param}/#{photo.to_param}"
  end
  
  def edit_url
    edit_photo_url(photo)
  end
    
  protected
  # Defer loading of associated objects
  def photo
    @photo ||= @object.photo
  end

  def photo_set
    @photo_set ||= @object.photo_set
  end
  
  def load_parent
    return photo_set.page
  end
end

Webpage.webpage_for_uri('photo/404') do
  def initialize(obj, depth = 0, locals = {})
    @uri = "/photo/404"
    @title = "404 Not Found"
    @updated_on = nil
    super
  end
  
  protected
  def load_parent; Comatose::PageWrapper.create_from_slug('home-page'); end
end
  