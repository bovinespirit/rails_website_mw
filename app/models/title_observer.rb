
class TitleObserver < ActiveRecord::Observer
  observe ComatosePage, Post
  
  def after_save(obj)
    ps = PhotoSet.find_by_obj(obj)
    ps.update_attribute('title', obj.title) unless ps.nil?
    true
  end
  
  def before_destroy(obj)
    ps = PhotoSet.find_by_obj(obj)
    ps.update_attribute('title', nil) unless ps.nil?
    true
  end    
end