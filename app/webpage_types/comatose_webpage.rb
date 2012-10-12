Webpage.webpage_for_class(Comatose::PageWrapper) do
  def initialize(obj, depth = 0, locals = {})
    @object = obj
    super
  end
  
  def title; @object.title; end
  def updated_on; @object.updated_on; end
  def menu_title; @object.menu_title; end
  alias crumb_title title
  
  def uri
    (@object.has_keyword?('url')) ? @object.body : @object.uri
  end
  
  def admin?
    return @object.has_keyword?('admin')
  end
  
  def edit_url
    "/admin/comatose_admin/edit/#{@object.id}"
  end
  
  def staging?
    @object.has_keyword?('staging')
  end
  
  protected
  def load_parent
    return @object.parent
  end
  
  def load_children
    ar = @object.children.to_a.dup
    return ar
  end
end # ComatoseWebpage


