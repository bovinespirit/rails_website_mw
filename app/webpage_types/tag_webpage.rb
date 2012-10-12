Webpage.webpage_for_class(Tag) do
  def initialize(obj, depth = 0, locals = {})
    @object = obj
    @uri = "/tags/#{@object.name}"
    @changefreq = :weekly
    super
  end

  def title
    "Tag - #{@object.name}"
  end
  
  def menu_title; @object.name; end
  alias crumb_title menu_title

  protected
  def load_parent
    "tags"
  end
end

Webpage.webpage_for_uri("tags") do
  def initialize(obj, depth = 0, locals = {})
    @object = obj
    @uri = "/tags"
    @changefreq = :weekly
    @title = "Tags"
    super
  end
  
  protected
  def load_parent
    return ComatosePage.find_by_slug('home-page')
  end
end
  