Webpage.webpage_for_uri("email") do
  def initialize(obj, depth = 0, locals = {})
    @uri = "/email"
    @title = "Contact Matthew West"
    @menu_title = "Contact Me"
    @updated_on = nil
    super(obj, depth)
  end
  
  def load_parent; Comatose::PageWrapper.create_from_slug('home-page'); end  
end
