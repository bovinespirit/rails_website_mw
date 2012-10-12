
class PhotoSweeper < ActionController::Caching::Sweeper

  observe Photo
  
  def after_create(photo)
  end
  
  def after_update(photo)
    expire_page(:controller => '/photo', :action => ['img', 'imgbg'], :photo => photo, :size => 'main.jpg')
    Photo::THUMB_SIZES.each { |k, v| expire_page(:controller => '/photo', 
                                                 :action => ['img', 'imgbg'], 
                                                 :photo => photo,
                                                 :size => "#{k}.jpg") }
#    photo.photo_set.photos.each do |ph|
#      expire_page(:controller => '/photo', :action => 'show', :slug => ph.slug)
#    end if photo.photo_set_id != 0
  end
end