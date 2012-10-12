Comatose.define_drop "photoset" do 
# Usage:
#
# examples:
#   {{ photoset.id_1 | thumb_cards: 'small', 'notitle' }}
#   {{ photoset.for_this_page | only_these: '1, 2, 3' | thumb_cards: 'medium', '', 'classes' }}

def before_method(method)
    @photo_set = nil
    @photos = []
    if method =~ /\Aid_([0-9]*)\Z/
      id = $~[1].to_i
      @photo_set = PhotoSet.find(id)
    elsif method == "for_this_page"
      page = @context['page']
      page = ComatosePage.find(@context['params']['page']['id']) unless page[:id]
      @photo_set = PhotoSet.find_by_obj(page)
    elsif method == "for_this"
      @photo_set = @context['obj'].photo_set
    end
    @photos = @photo_set.photos.collect { |photo| photo[:id] } if @photo_set
    return self
  end
  
  def count
    @photos.size
  end
  
  def title_source
    return :photo
  end
  
  # Removes any photos whose IDs aren't in ar
  def only(ar)
    @photos.delete_if { |pid| !ar.include?(pid) }
    return self
  end
  
  def photos(&block)
    @photos.each do |photo_id|
      yield @photo_set, Photo.find(photo_id)  
    end
  end
end
