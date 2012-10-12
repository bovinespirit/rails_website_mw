
Webpage.webpage_for_uri("admin") do
  def initialize(obj, depth = 0, locals = {})
    @uri = "/admin"
    @title = "Administrative Pages"
    @menu_title = "Admin"
    @updated_on = nil
    @admin = true
    super
  end
  
  def load_parent; Comatose::PageWrapper.create_from_slug('home-page'); end
  def load_children; ["admin/posts", "admin/photos", "admin/photo_sets",
                      "admin/comatose_admin", "admin/contacts", 
                      "admin/redirections", "admin/tags", "admin/logout"]; end
end

Webpage.webpage_for_uri("admin/login") do
  def initialize(obj, depth = 0, locals = {})
    @uri = "/admin/login" # Nasty bodge to make this look like admin page to Webpage
    @title = "Administrative Pages Login"
    @menu_title = "Login"
    @updated_on = nil
    @admin = false
    super
  end
  
  def load_parent; "admin"; end
end

Webpage.webpage_for_uri("admin/logout") do
  def initialize(obj, depth = 0, locals = {})
    @uri = "/admin/login"
    @title = "Administrative Pages Logout"
    @menu_title = "Logout"
    @updated_on = nil
    @admin = true
    super
  end
  
  def load_parent; "admin"; end
end

Webpage.webpage_for_uri("admin/photos") do
  def initialize(obj, depth = 0, locals = {})
    @uri = "/admin/photos"
    @title = "Edit Photos"
    @updated_on = nil
    @admin = true
    super
  end
  
  def load_parent; "admin"; end
end

Webpage.webpage_for_uri("admin/photo_sets") do
  def initialize(obj, depth = 0, locals = {})
    @uri = "/admin/photo_sets"
    @title = "Edit Photo Sets"
    @updated_on = nil
    @admin = true
    super
  end
  
  def load_parent; "admin"; end
end

Webpage.webpage_for_uri("admin/comatose_admin") do
  def initialize(obj, depth = 0, locals = {})
    @uri = "/admin/comatose_admin"
    @title = "Comatose"
    @updated_on = nil
    @admin = true
    super
  end
  
  def load_parent; "admin"; end
end

Webpage.webpage_for_uri("admin/redirections") do
  def initialize(obj, depth = 0, locals = {})
    @uri = "/admin/redirections"
    @title = "Redirections"
    @updated_on = nil
    @admin = true
    super
  end
  
  def load_parent; "admin"; end
end

Webpage.webpage_for_uri("admin/contacts") do
  def initialize(obj, depth = 0, locals = {})
    @uri = "/admin/contacts"
    @title = "Contacts"
    @updated_on = nil
    @admin = true
    super
  end
  
  def load_parent; "admin"; end
end

Webpage.webpage_for_uri("admin/posts") do
  def initialize(obj, depth = 0, locals = {})
    @uri = "/admin/posts"
    @title = "Blog Posts"
    @updated_on = nil
    @admin = true
    super
  end
  
  def load_parent; "admin"; end
end

Webpage.webpage_for_uri("admin/tags") do
  def initialize(obj, depth = 0, locals = {})
    @uri = "/admin/tags"
    @title = "Tags"
    @updated_on = nil
    @admin = true
    super
  end
  
  def load_parent; "admin"; end
end
