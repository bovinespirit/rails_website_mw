Comatose.define_drop "photosets" do
  def contents
    @photo_sets = []
    page = @context['page']
    page = ComatosePage.find(@context['params']['page']['id']) unless page[:id]
    children = page.children
    children.each do |child|
      photo_set = PhotoSet.find_by_obj(child)
      @photo_sets << photo_set unless photo_set.nil?
    end
    return self
  end

  def count
    @photo_sets.size
  end
  
  def title_source
    return :photo_set
  end
  
  def photos(&block)
    @photo_sets.each do |photo_set|
      yield photo_set, photo_set.contents_photo  
    end
  end
end