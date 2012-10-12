Webpage.webpage_for_uri("404") do
  def initialize(obj, depth = 0, locals = {})
    @uri = "/404"
    @title = "404 Not Found"
    @updated_on = nil
    super(obj, depth)
  end
  
  def load_parent; Comatose::PageWrapper.create_from_slug('home-page'); end
  def has_next?; false; end
  def has_prev?; false; end
end
